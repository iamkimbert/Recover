//
//  Surveys.swift
//  Recover
//
//  Created by Kimberly Townsend on 9/15/22.
//

import CareKitStore
import ResearchKit

struct Surveys {
    
    private init(){}
    
    // Mark: Onboarding
    
    //1.4 Construct an ORKTask for onboarding
    static func onboardingSurvey() -> ORKTask {
        
        // 1.4.1 Welcome Instruction Step
        let welcomeInstructionStep = ORKInstructionStep(
            identifier: "onboarding.welcome"
        )
        
        welcomeInstructionStep.title = "Welcome!"
        welcomeInstructionStep.detailText = "Thankyou for joining our study. Tap Next to learn more before signing up."
        welcomeInstructionStep.image = UIImage(named: "welcome-image")!
        welcomeInstructionStep.imageContentMode = .scaleAspectFill
        
        // 1.4.2 Informed Consent Instruction step
        let studyOverviewInstructionStep = ORKInstructionStep(
            identifier: "onboarding.overview"
        )
        
        studyOverviewInstructionStep.title = "Before You Join"
        studyOverviewInstructionStep.image = UIImage(systemName: "checkmark.seal.fill")!
        
        let heartBodyItem = ORKBodyItem(
            text: "The study will ask you to share some of your Health data.",
            detailText: nil,
            image: UIImage(systemName: "heart.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let completeTasksBodyItem = ORKBodyItem(
            text: "You will be asked to complete various tasks over the duration of the study.",
            detailText: nil,
            image: UIImage(systemName: "checkmark.circle.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let signatureBodyItem = ORKBodyItem(
            text: "Before joining, we will ask you to sign an informed consent document.",
            detailText: nil,
            image: UIImage(systemName: "signature"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let secureDataBodyItem = ORKBodyItem(
            text: "Your data is kept private and secure.",
            detailText: nil,
            image: UIImage(systemName: "lock.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        studyOverviewInstructionStep.bodyItems = [
            heartBodyItem,
            completeTasksBodyItem,
            signatureBodyItem,
            secureDataBodyItem
        ]
        // 1.4.3 Signature (via WebView Step)
        let webViewStep = ORKWebView Step(
            identifier: "onboarding.signatureCapture",
            html: informedConsentHTML
        )
        
        webViewStep.showSignatureAfterContent = true
        
        // 1.4.4 Request Permissions Step
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
            HKObectType.quantityType(forIdentifier: .appleExerciseTime)!,
        ]
        
        let healthKitPermissionType = ORKHealthKitPermissionType(
            sampleTypesToWrite: healthKitTypesToWrite,
            objectTypesToRead: healthKitTypesToRead
        )
        
        let notificationsPermissionType = ORKNotificationPermissionType(
            authorizationOptions: [.alert, .badge,.sound]
        )
        
        let motionPermissionType = ORKMotionActivityPermissionType()
        
        let requestPermissionsStep = ORKRequestPermissionsStep(
            identifier: "onboarding.requestPermissionsStep",
            permissionTypes: [
                healthKitPermissionType,
                notificationsPermissionType,
                motionPermissionType
            
            ]
        )
        
        requestPermissionsStep.title = "Health Data Request"
        requestPermissionsStep.text = "Please review the health data types below and enable sharing to contribute to the study."
        
        // 1.4.5 Completion Step
        
        let completionStep = ORKCompletionStep(identifier: "onboarding.completionStep")
        completionStep.title = " Enrollment Complete"
        completionStep.text = "Thank you for enrolling in this study. Your participation will contribute to meaningful research!"
        
        let surveyTask = ORKOrderedTask(
            identifier: "onboard",
            steps: [
                welcomeInstructionStep,
                studyOverviewInstructionStep,
                webViewStep,
                requestPermissionsStep,
                completionStep
            ]
        )
        
        return surveyTask
    }
}
