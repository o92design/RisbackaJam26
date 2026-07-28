pipeline {
    agent any

    environment {
        UE_ROOT       = 'C:\\Epic\\UE_5.8'
        BUTLER_PATH   = 'C:\\Tools\\butler\\butler.exe'
        ARCHIVE_ROOT  = 'D:\\RisbackaJam26'
        ITCH_TARGET   = 'kioskars/risbacka-jam-26'
        ITCH_CHANNEL  = 'windows-test'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
        timestamps()
        timeout(time: 90, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                bat(label: 'Install and pull Git LFS', script: '''
                    @git lfs install --local
                    @git lfs pull
                ''')
            }
        }

        stage('Git LFS validation') {
            steps {
                powershell(label: 'Validate LFS pointers', script: '& .\\Scripts\\CI\\Test-Lfs.ps1')
            }
        }

        stage('Build context') {
            steps {
                powershell(
                    label: 'Capture reproducible build metadata',
                    script: '& .\\Scripts\\CI\\New-BuildContext.ps1 -Configuration Development -Stream Test -Channel windows-test'
                )
            }
        }

        stage('Preflight') {
            steps {
                powershell(label: 'Check tools and SSD space', script: '& .\\Scripts\\CI\\Test-Preflight.ps1')
            }
        }

        stage('Project validation') {
            steps {
                powershell(label: 'Validate Unreal project contract', script: '& .\\Scripts\\CI\\Test-Project.ps1')
            }
        }

        stage('Blueprint functional tests') {
            steps {
                powershell(label: 'Run headless Unreal tests', script: '& .\\Scripts\\CI\\Run-UnrealTests.ps1')
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'TestOutput/junit.xml'
                }
            }
        }

        stage('Build, cook, stage, package') {
            steps {
                powershell(label: 'Run the proven Unreal BuildCookRun flow', script: '& .\\Scripts\\CI\\Build-Package.ps1 -Configuration Development')
            }
        }

        stage('Package verification') {
            steps {
                powershell(label: 'Verify output and run startup smoke test', script: '& .\\Scripts\\CI\\Verify-Package.ps1')
            }
        }

        stage('Required immutable archive') {
            steps {
                powershell(label: 'Archive package, diagnostics, and checksums', script: '& .\\Scripts\\CI\\Publish-Archive.ps1 -Result Success')
            }
        }

        stage('Upload to itch.io test') {
            steps {
                withCredentials([string(credentialsId: 'itch-butler-api-key', variable: 'BUTLER_API_KEY')]) {
                    powershell(
                        label: 'Butler differential upload',
                        script: '& .\\Scripts\\CI\\Upload-Butler.ps1 -Channel windows-test'
                    )
                }
            }
        }
    }

    post {
        always {
            script {
                def archiveResult = currentBuild.currentResult == 'SUCCESS' ? 'Success' :
                    (currentBuild.currentResult == 'UNSTABLE' ? 'Unstable' : 'Failure')
                catchError(buildResult: currentBuild.currentResult, stageResult: 'FAILURE') {
                    powershell(
                        label: 'Finalize archive outcome',
                        script: "& .\\Scripts\\CI\\Finalize-Archive.ps1 -Result ${archiveResult}"
                    )
                }
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    powershell(label: 'Regenerate static dashboard', script: '& .\\Scripts\\CI\\Update-Dashboard.ps1')
                }
            }
            archiveArtifacts(
                allowEmptyArchive: true,
                artifacts: 'BuildLogs/**,BuildMetadata/**,TestOutput/**',
                fingerprint: false
            )
        }
    }
}
