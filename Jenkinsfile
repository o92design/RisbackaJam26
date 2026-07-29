pipeline {
    agent any

    environment {
        UE_ROOT       = 'C:\\Epic\\UE_5.8'
        BUTLER_PATH   = 'C:\\Tools\\butler\\butler.exe'
        ARCHIVE_ROOT  = 'D:\\RisbackaJam26'
        ITCH_TARGET   = 'kioskars/risbacka-jam-26'
        ITCH_CHANNEL  = 'windows-test'
        DASHBOARD_PUBLISH_ROOT = 'C:\\ProgramData\\Jenkins\\.jenkins\\userContent\\RisbackaJam26'
        GIT_LFS_SKIP_SMUDGE = '1'
        CI_SKIP_EXPENSIVE   = 'false'
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
            }
        }

        stage('Classify changes') {
            steps {
                script {
                    def changedPaths = currentBuild.changeSets
                        .collectMany { changeSet ->
                            changeSet.items.collectMany { entry ->
                                entry.affectedFiles.collect { file -> file.path }
                            }
                        }
                        .findAll { path -> path }
                        .collect { path -> path.replace('\\', '/') }
                        .unique()
                        .sort()

                    def scmTriggered = !currentBuild
                        .getBuildCauses('hudson.triggers.SCMTrigger$SCMTriggerCause')
                        .isEmpty()
                    def collaborationOnly = { path ->
                        def lowerPath = path.toLowerCase()
                        lowerPath.endsWith('.md') ||
                            lowerPath == '.gitignore' ||
                            lowerPath.endsWith('/.gitignore') ||
                            lowerPath == '.editorconfig' ||
                            lowerPath.endsWith('/.editorconfig') ||
                            lowerPath == '.codex' ||
                            lowerPath.startsWith('.codex/') ||
                            lowerPath == '.agents' ||
                            lowerPath.startsWith('.agents/') ||
                            lowerPath == '.obsidian' ||
                            lowerPath.startsWith('.obsidian/')
                    }

                    if (scmTriggered &&
                        !changedPaths.isEmpty() &&
                        changedPaths.every { path -> collaborationOnly(path) }) {
                        env.CI_SKIP_EXPENSIVE = 'true'
                        def shortCommit = env.GIT_COMMIT ? env.GIT_COMMIT.take(12) : 'unknown'
                        currentBuild.displayName = "Skipped-${env.BUILD_NUMBER}-${shortCommit}"
                        currentBuild.description =
                            "Collaboration-only SCM change; skipped Unreal CI (${changedPaths.size()} file(s))"
                        echo "Collaboration-only SCM change; skipping Unreal CI: ${changedPaths.join(', ')}"
                    } else {
                        echo changedPaths.isEmpty()
                            ? 'No reliable SCM change set was found; running full CI.'
                            : "Build-relevant change detected; running full CI: ${changedPaths.join(', ')}"
                    }
                }
            }
        }

        stage('Git LFS pull') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                bat(label: 'Install and pull Git LFS', script: '''
                    @git lfs install --local
                    @git lfs pull
                ''')
            }
        }

        stage('Git LFS validation') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Validate LFS pointers', script: '& .\\Scripts\\CI\\Test-Lfs.ps1')
            }
        }

        stage('Build context') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(
                    label: 'Capture reproducible build metadata',
                    script: '& .\\Scripts\\CI\\New-BuildContext.ps1 -Configuration Development -Stream Test -Channel windows-test'
                )
                script {
                    currentBuild.displayName = powershell(
                        label: 'Apply informative Jenkins build name',
                        returnStdout: true,
                        script: "(Get-Content -Raw -LiteralPath '.\\BuildMetadata\\BuildContext.json' | ConvertFrom-Json).buildId"
                    ).trim()
                }
            }
        }

        stage('Preflight') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Check tools and SSD space', script: '& .\\Scripts\\CI\\Test-Preflight.ps1')
            }
        }

        stage('Project validation') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Validate Unreal project contract', script: '& .\\Scripts\\CI\\Test-Project.ps1')
            }
        }

        stage('Blueprint functional tests') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Run headless Unreal tests', script: '& .\\Scripts\\CI\\Run-UnrealTests.ps1')
            }
            post {
                always {
                    script {
                        if (env.CI_SKIP_EXPENSIVE != 'true') {
                            junit allowEmptyResults: true, testResults: 'TestOutput/junit.xml'
                        }
                    }
                }
            }
        }

        stage('Build, cook, stage, package') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Run the proven Unreal BuildCookRun flow', script: '& .\\Scripts\\CI\\Build-Package.ps1 -Configuration Development')
            }
        }

        stage('Package verification') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Verify output and run startup smoke test', script: '& .\\Scripts\\CI\\Verify-Package.ps1')
            }
        }

        stage('Required immutable archive') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
            steps {
                powershell(label: 'Archive package, diagnostics, and checksums', script: '& .\\Scripts\\CI\\Publish-Archive.ps1 -Result Success')
            }
        }

        stage('Upload to itch.io test') {
            when {
                expression { env.CI_SKIP_EXPENSIVE != 'true' }
            }
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
                if (env.CI_SKIP_EXPENSIVE == 'true') {
                    echo 'Collaboration-only run completed without Unreal build artifacts.'
                } else {
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
                    archiveArtifacts(
                        allowEmptyArchive: true,
                        artifacts: 'BuildLogs/**,BuildMetadata/**,TestOutput/**',
                        fingerprint: false
                    )
                }
            }
        }
    }
}
