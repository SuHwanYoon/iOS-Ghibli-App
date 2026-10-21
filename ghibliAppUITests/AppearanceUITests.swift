//
//  AppearanceUITests.swift
//  ghibliAppUITests
//
//  Created by Antigravity on 2026/10/18.
//

import XCTest

final class AppearanceUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // 깨끗한 초기 상태 테스트를 위한 아규먼트 주입 가능
        app.launchArguments += ["-AppleLanguages", "(ko-KR)", "-AppleLocale", "ko_KR"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helper Methods

    /// 설정 탭으로 전환하는 헬퍼 메서드
    private func navigateToSettingsTab() {
        let tabBars = app.tabBars
        let settingsButton = tabBars.buttons["설정"]

        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else if tabBars.buttons["Settings"].exists {
            tabBars.buttons["Settings"].tap()
        } else {
            // 인덱스 기반 폴백 (4번째 탭)
            let tabCount = tabBars.buttons.count
            if tabCount >= 4 {
                tabBars.buttons.element(boundBy: 3).tap()
            } else if tabCount > 0 {
                tabBars.buttons.element(boundBy: tabCount - 1).tap()
            }
        }
    }

    /// 외관 모드 행 버튼 반환 헬퍼
    private func getAppearanceButton(for mode: String) -> XCUIElement {
        let button = app.buttons["appearance_option_\(mode)"]
        _ = button.waitForExistence(timeout: 5.0)
        return button
    }

    // MARK: - UI Tests

    @MainActor
    func testNavigateToSettingsAndVerifyAppearancePickerExists() throws {
        // 1. 설정 탭으로 진입
        navigateToSettingsTab()

        // 2. 3가지 외관 모드(시스템, 라이트, 다크) 행 버튼 노출 확인
        let systemButton = getAppearanceButton(for: "system")
        let lightButton = getAppearanceButton(for: "light")
        let darkButton = getAppearanceButton(for: "dark")

        XCTAssertTrue(systemButton.exists, "System appearance option should exist")
        XCTAssertTrue(lightButton.exists, "Light appearance option should exist")
        XCTAssertTrue(darkButton.exists, "Dark appearance option should exist")
    }

    @MainActor
    func testSwitchingAppearanceModesUpdatesSelection() throws {
        // 1. 설정 탭 진입
        navigateToSettingsTab()

        let systemButton = getAppearanceButton(for: "system")
        let lightButton = getAppearanceButton(for: "light")
        let darkButton = getAppearanceButton(for: "dark")

        // 2. 다크 모드 탭 및 선택 확인
        darkButton.tap()
        XCTAssertTrue(darkButton.isSelected, "Dark mode option should be selected after tap")

        // 3. 라이트 모드 탭 및 선택 확인
        lightButton.tap()
        XCTAssertTrue(lightButton.isSelected, "Light mode option should be selected after tap")

        // 4. 시스템 모드 탭 및 선택 복귀 확인
        systemButton.tap()
        XCTAssertTrue(systemButton.isSelected, "System mode option should be selected after tap")
    }

    @MainActor
    func testAppearancePersistenceAcrossAppRelaunch() throws {
        // 1. 설정 탭 진입 후 다크 모드로 변경
        navigateToSettingsTab()
        let darkButton = getAppearanceButton(for: "dark")
        darkButton.tap()
        XCTAssertTrue(darkButton.isSelected)

        // 2. 앱 종료 및 재실행 (프로세스 강제 종료 시뮬레이션)
        app.terminate()
        app.launch()

        // 3. 설정 탭 재진입
        navigateToSettingsTab()
        let reloadedDarkButton = getAppearanceButton(for: "dark")

        // 4. 다크 모드 선택 상태가 유지되는지 영속성 검증
        XCTAssertTrue(reloadedDarkButton.isSelected, "Selected appearance mode should persist across app relaunches via AppStorage/UserDefaults")
    }

    @MainActor
    func testChaosRapidTappingOnAppearancePicker() throws {
        // 1. 설정 탭 진입
        navigateToSettingsTab()

        let systemButton = getAppearanceButton(for: "system")
        let lightButton = getAppearanceButton(for: "light")
        let darkButton = getAppearanceButton(for: "dark")

        // 2. 극한의 빠른 연속 탭 (카오스 테스트: 레이스 컨디션 및 메인 스레드 멈춤/크래시 여부 검증)
        for _ in 0..<10 {
            darkButton.tap()
            systemButton.tap()
            lightButton.tap()
        }

        // 3. 마지막 선택 상태가 정상적으로 라이트 모드로 정착되었는지 검증
        XCTAssertTrue(lightButton.isSelected, "Final state should be stable and correctly selected without UI freezing or crash")
    }
}
