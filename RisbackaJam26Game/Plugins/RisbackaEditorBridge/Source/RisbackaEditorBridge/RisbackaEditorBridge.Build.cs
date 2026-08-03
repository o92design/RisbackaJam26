using UnrealBuildTool;

public class RisbackaEditorBridge : ModuleRules
{
	public RisbackaEditorBridge(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = ModuleRules.PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(
			new string[]
			{
				"Core",
				"CoreUObject",
				"Engine",
			}
		);

		// UnrealEd supplies FBlueprintEditorUtils and FKismetEditorUtilities.
		PrivateDependencyModuleNames.AddRange(
			new string[]
			{
				"UnrealEd",
			}
		);
	}
}
