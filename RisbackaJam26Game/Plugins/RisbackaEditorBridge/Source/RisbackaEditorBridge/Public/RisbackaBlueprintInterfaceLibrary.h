#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "RisbackaBlueprintInterfaceLibrary.generated.h"

class UBlueprint;

/**
 * Editor-only helpers for Blueprint interface implementation.
 *
 * Unreal exposes no scripted way to add an interface to a Blueprint:
 * UBlueprint::ImplementedInterfaces is not script-visible and
 * FBPInterfaceDescription is not reflected, so neither the editor Python API
 * nor TAPython can reach it. FBlueprintEditorUtils::ImplementNewInterface is a
 * C++ static rather than a UFUNCTION, so reflection cannot call it either.
 * This library wraps it so the whole contract pipeline stays automated.
 */
UCLASS()
class RISBACKAEDITORBRIDGE_API URisbackaBlueprintInterfaceLibrary : public UBlueprintFunctionLibrary
{
	GENERATED_BODY()

public:
	/**
	 * Adds InterfaceClass to Blueprint's implemented interfaces, then compiles.
	 * Idempotent: returns true if the interface is already implemented.
	 * Does not save the asset; the caller decides when to save.
	 *
	 * @param Blueprint       The Blueprint to modify.
	 * @param InterfaceClass  The interface class. For a Blueprint Interface this
	 *                        is the generated class, e.g. BPI_Foo_C.
	 * @return True if the interface is implemented once this returns.
	 */
	UFUNCTION(BlueprintCallable, Category = "Risbacka|Editor|Blueprint")
	static bool ImplementInterface(UBlueprint* Blueprint, UClass* InterfaceClass);

	/** Removes InterfaceClass from Blueprint, then compiles. Idempotent. */
	UFUNCTION(BlueprintCallable, Category = "Risbacka|Editor|Blueprint")
	static bool RemoveImplementedInterface(UBlueprint* Blueprint, UClass* InterfaceClass,
		bool bPreserveFunctions = false);

	/** Returns the interface classes Blueprint currently implements directly. */
	UFUNCTION(BlueprintPure, Category = "Risbacka|Editor|Blueprint")
	static TArray<UClass*> GetImplementedInterfaces(UBlueprint* Blueprint);
};
