//
//  SettingScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

/// 설정 화면 메인 뷰입니다.
/// 화면 모드(Appearance), 언어 설정 및 앱 정보를 체계적으로 관리합니다.
struct SettingScreen: View {
    // UserDefaults에 저장되는 영구 화면 모드 및 언어 설정
    @AppStorage(AppAppearance.storageKey) private var selectedAppearanceRaw: String = AppAppearance.system.rawValue
    @AppStorage("appLanguage") private var selectedLanguageRaw: String = AppLanguage.system.rawValue

    /// 타입 안전한 AppAppearance 바인딩
    private var selectedAppearanceBinding: Binding<AppAppearance> {
        Binding(
            get: { AppAppearance.from(rawValue: selectedAppearanceRaw) },
            set: { newAppearance in
                selectedAppearanceRaw = newAppearance.rawValue
                newAppearance.apply()
            }
        )
    }

    /// 타입 안전한 AppLanguage 바인딩
    private var selectedLanguageBinding: Binding<AppLanguage> {
        Binding(
            get: { AppLanguage(rawValue: selectedLanguageRaw) ?? .system },
            set: { selectedLanguageRaw = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                // 1. 화면 외관 모드 섹션 (System, Light, Dark)
                AppearanceSectionView(selectedAppearance: selectedAppearanceBinding)

                // 2. 언어 설정 섹션
                LanguageSectionView(selectedLanguage: selectedLanguageBinding)

                // 3. 앱 정보 섹션
                AppInfoSectionView()

                // 4. 지원 및 법적 고지 섹션 (개인정보처리방침, 문의하기, 면책조항)
                SupportAndLegalSectionView()
            }
            .accessibilityIdentifier("settings_form")
            .onAppear {
                AppAppearance.from(rawValue: selectedAppearanceRaw).apply()
            }
            .onChange(of: selectedAppearanceRaw) { _, newValue in
                AppAppearance.from(rawValue: newValue).apply()
            }
        }
    }
}

// MARK: - 1. Appearance Section View

/// 화면 모드(Appearance) 설정 섹션 뷰입니다.
struct AppearanceSectionView: View {
    @Binding var selectedAppearance: AppAppearance

    var body: some View {
        Section {
            // HIG 규격: 터치 영역 44pt 보장 및 시각적 피드백 상세 행 목록
            ForEach(AppAppearance.allCases) { appearance in
                AppearanceOptionRowView(
                    appearance: appearance,
                    isSelected: selectedAppearance == appearance
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedAppearance = appearance
                    }
                }
            }
        } header: {
            Text("settings_section_appearance")
                .accessibilityAddTraits(.isHeader)
        } footer: {
            Text("settings_appearance_footer")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .accessibilityIdentifier("settings_appearance_section")
        .sensoryFeedback(.selection, trigger: selectedAppearance)
    }
}

// MARK: - 2. Appearance Option Row View (Equatable Optimized)

/// 단일 화면 모드 행 컴포넌트입니다.
/// Equatable 프로토콜을 채택하여 선택 상태가 변경된 항목만 선별적으로 리렌더링하여 불필요한 body 재연산을 방지합니다.
struct AppearanceOptionRowView: View, Equatable {
    let appearance: AppAppearance
    let isSelected: Bool
    let onSelect: () -> Void

    @ScaledMetric private var iconSize: CGFloat = 16
    @ScaledMetric private var iconBoxSize: CGFloat = 28

    // Equatable 구현: appearance와 isSelected 상태가 동일할 경우 불필요한 body 재연산 방지
    static func == (lhs: AppearanceOptionRowView, rhs: AppearanceOptionRowView) -> Bool {
        lhs.appearance == rhs.appearance && lhs.isSelected == rhs.isSelected
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                // HIG 규격: 색상 배경의 둥근 모서리 아이콘 컨테이너
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(appearance.iconTintColor.gradient)
                        .frame(width: iconBoxSize, height: iconBoxSize)

                    Image(systemName: appearance.iconName)
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .accessibilityHidden(true)

                Text(appearance.titleKey)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityHidden(true)
                }
            }
            // Apple HIG 권장 터치 영역: 최소 44x44pt 확보 및 전체 행 탭 활성화
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
        .accessibilityHint(appearance.accessibilityHintKey)
        .accessibilityIdentifier("appearance_option_\(appearance.rawValue)")
    }
}

// MARK: - 3. Language Section View

/// 언어 설정 섹션 뷰입니다.
struct LanguageSectionView: View {
    @Binding var selectedLanguage: AppLanguage

    @ScaledMetric private var iconSize: CGFloat = 16
    @ScaledMetric private var iconBoxSize: CGFloat = 28

    var body: some View {
        Section {
            Picker(selection: $selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName)
                        .tag(language)
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.teal.gradient)
                            .frame(width: iconBoxSize, height: iconBoxSize)

                        Image(systemName: "globe")
                            .font(.system(size: iconSize, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .accessibilityHidden(true)

                    Text("settings_section_language")
                        .font(.body)
                        .foregroundStyle(.primary)
                }
            }
            .pickerStyle(.navigationLink)
            .frame(minHeight: 44)
            .accessibilityIdentifier("language_picker")
        } header: {
            Text("settings_section_language")
                .accessibilityAddTraits(.isHeader)
        }
        .accessibilityIdentifier("settings_language_section")
        .sensoryFeedback(.selection, trigger: selectedLanguage)
    }
}

// MARK: - 4. App Info Section View

/// 앱 정보 및 버전 표시 섹션 뷰입니다.
struct AppInfoSectionView: View {
    @ScaledMetric private var iconSize: CGFloat = 16
    @ScaledMetric private var iconBoxSize: CGFloat = 28

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        Section {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.gray.gradient)
                        .frame(width: iconBoxSize, height: iconBoxSize)

                    Image(systemName: "info.circle.fill")
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .accessibilityHidden(true)

                Text("settings_app_version")
                    .font(.body)

                Spacer()

                Text("\(appVersion) (\(buildNumber))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(minHeight: 44)
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("settings_version_row")
        } header: {
            Text("settings_section_about")
                .accessibilityAddTraits(.isHeader)
        }
        .accessibilityIdentifier("settings_about_section")
    }
}

// MARK: - 5. Support & Legal Section View

/// 지원 및 법적 고지(개인정보처리방침, 문의 메일, 면책 조항) 섹션 뷰입니다.
struct SupportAndLegalSectionView: View {
    @ScaledMetric private var iconSize: CGFloat = 16
    @ScaledMetric private var iconBoxSize: CGFloat = 28

    @AppStorage("appLanguage") private var selectedLanguageRaw: String = AppLanguage.system.rawValue
    @State private var isShowingEmailCopiedAlert = false

    /// 개발자 문의 이메일 (스토어 지원용)
    private let supportEmail = "suhwan6@gmail.com"

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguageRaw) ?? .system
    }

    /// 현재 언어 설정(ko, en, ja)에 맞춘 다국어 개인정보 처리방침 GitHub Pages URL
    private var privacyPolicyURL: URL? {
        let langCode = currentLanguage.effectiveLanguageCode
        return URL(string: "https://suhwanyoon.github.io/iOS-Ghibli-App/privacy/\(langCode).html")
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var body: some View {
        Section {
            // 1. 개인정보 처리방침 링크 (현재 언어에 맞춰 자동 분기)
            if let url = privacyPolicyURL {
                Link(destination: url) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.blue.gradient)
                                .frame(width: iconBoxSize, height: iconBoxSize)

                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: iconSize, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .accessibilityHidden(true)

                        Text("settings_privacy_policy")
                            .font(.body)
                            .foregroundStyle(.primary)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)
                    }
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .accessibilityIdentifier("settings_privacy_policy_link")
            }

            // 2. 개발자 문의하기 (메일 전송 또는 클립보드 복사)
            Button(action: handleContactDeveloper) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.orange.gradient)
                            .frame(width: iconBoxSize, height: iconBoxSize)

                        Image(systemName: "envelope.fill")
                            .font(.system(size: iconSize, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .accessibilityHidden(true)

                    Text("settings_contact_us")
                        .font(.body)
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("settings_contact_us_button")
        } header: {
            Text("settings_section_support")
                .accessibilityAddTraits(.isHeader)
        } footer: {
            // 3. 지브리 IP 면책 조항 (Apple 심사 Guideline 5.2.1 리젝 방지)
            VStack(alignment: .leading, spacing: 6) {
                Text("settings_disclaimer_title")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Text("settings_disclaimer_text")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("settings_disclaimer_footer")
        }
        .accessibilityIdentifier("settings_support_section")
        .alert("settings_contact_email_copied_title", isPresented: $isShowingEmailCopiedAlert) {
            Button("common_ok", role: .cancel) {}
        } message: {
            Text(String(localized: "settings_contact_email_copied_message \(supportEmail)"))
        }
    }

    /// 문의 메일 핸들러: Mail 앱이 있으면 열고, 없으면 이메일 주소를 클립보드에 복사
    private func handleContactDeveloper() {
        let subject = "Dotori Film Support (v\(appVersion))"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailtoURLString = "mailto:\(supportEmail)?subject=\(encodedSubject)"

        if let mailtoURL = URL(string: mailtoURLString), UIApplication.shared.canOpenURL(mailtoURL) {
            UIApplication.shared.open(mailtoURL)
        } else {
            UIPasteboard.general.string = supportEmail
            isShowingEmailCopiedAlert = true
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    SettingScreen()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SettingScreen()
        .preferredColorScheme(.dark)
}
