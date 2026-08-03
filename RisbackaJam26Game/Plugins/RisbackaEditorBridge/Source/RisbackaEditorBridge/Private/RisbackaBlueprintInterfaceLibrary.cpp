#include "RisbackaBlueprintInterfaceLibrary.h"

#include "Engine/Blueprint.h"
#include "Kismet2/BlueprintEditorUtils.h"
#include "Kismet2/KismetEditorUtilities.h"
#include "UObject/Class.h"
#include "UObject/TopLevelAssetPath.h"

namespace
{
	bool AlreadyImplements(const UBlueprint* Blueprint, const UClass* InterfaceClass)
	{
		for (const FBPInterfaceDescription& Description : Blueprint->ImplementedInterfaces)
		{
			if (Description.Interface.Get() == InterfaceClass)
			{
				return true;
			}
		}
		return false;
	}
}

bool URisbackaBlueprintInterfaceLibrary::ImplementInterface(UBlueprint* Blueprint, UClass* InterfaceClass)
{
	if (Blueprint == nullptr || InterfaceClass == nullptr)
	{
		return false;
	}

	if (AlreadyImplements(Blueprint, InterfaceClass))
	{
		return true;
	}

	const FTopLevelAssetPath InterfacePath = InterfaceClass->GetClassPathName();
	if (!FBlueprintEditorUtils::ImplementNewInterface(Blueprint, InterfacePath))
	{
		return false;
	}

	FBlueprintEditorUtils::MarkBlueprintAsStructurallyModified(Blueprint);
	FKismetEditorUtilities::CompileBlueprint(Blueprint);

	return AlreadyImplements(Blueprint, InterfaceClass);
}

bool URisbackaBlueprintInterfaceLibrary::RemoveImplementedInterface(UBlueprint* Blueprint,
	UClass* InterfaceClass, bool bPreserveFunctions)
{
	if (Blueprint == nullptr || InterfaceClass == nullptr)
	{
		return false;
	}

	if (!AlreadyImplements(Blueprint, InterfaceClass))
	{
		return true;
	}

	const FTopLevelAssetPath InterfacePath = InterfaceClass->GetClassPathName();
	FBlueprintEditorUtils::RemoveInterface(Blueprint, InterfacePath, bPreserveFunctions);

	FBlueprintEditorUtils::MarkBlueprintAsStructurallyModified(Blueprint);
	FKismetEditorUtilities::CompileBlueprint(Blueprint);

	return !AlreadyImplements(Blueprint, InterfaceClass);
}

TArray<UClass*> URisbackaBlueprintInterfaceLibrary::GetImplementedInterfaces(UBlueprint* Blueprint)
{
	TArray<UClass*> Interfaces;
	if (Blueprint == nullptr)
	{
		return Interfaces;
	}

	for (const FBPInterfaceDescription& Description : Blueprint->ImplementedInterfaces)
	{
		if (UClass* InterfaceClass = Description.Interface.Get())
		{
			Interfaces.Add(InterfaceClass);
		}
	}
	return Interfaces;
}
