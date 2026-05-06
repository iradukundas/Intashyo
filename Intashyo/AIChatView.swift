// AIChatView.swift — Screen 07

import SwiftUI

struct AIChatView: View {
    @Environment(AppState.self) private var appState
    var onBack: (() -> Void)? = nil
    var initialPrompt: String? = nil

    @State private var aiService = AIService()
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @FocusState private var inputFocused: Bool
    @State private var scrollProxy: ScrollViewProxy? = nil

    private var L: L { appState.L }

    var body: some View {
        VStack(spacing: 0) {
            chatHeader
            Divider().background(Color.faint)

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if messages.isEmpty && !isLoading {
                            suggestedPrompts
                                .id("top")
                        }

                        ForEach(messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)
                        }

                        if isLoading {
                            TypingBubble().id("typing")
                        }

                        if let err = errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.appRed)
                                Text(err)
                                    .font(.jakarta(13))
                                    .foregroundColor(.appRed)
                                Spacer()
                                Button(L.skipNow) { errorMessage = nil }
                                    .font(.jakarta(12, weight: .semibold))
                                    .foregroundColor(.muted)
                            }
                            .padding(12)
                            .background(Color.redBg)
                            .cornerRadius(12)
                            .padding(.horizontal, Spacing.lg)
                            .id("error")
                        }

                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom") }
                }
                .onChange(of: isLoading) { _, loading in
                    if loading { withAnimation { proxy.scrollTo("bottom") } }
                }
                .onAppear { scrollProxy = proxy }
            }

            inputBar
        }
        .background(Color.bg.ignoresSafeArea())
        .onAppear {
            if let prompt = initialPrompt, !prompt.isEmpty {
                sendMessage(prompt)
            }
        }
    }

    // MARK: - Header

    private var chatHeader: some View {
        HStack(spacing: 12) {
            if let back = onBack {
                BackButton(action: back)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accent)
                    .frame(width: 36, height: 36)
                Text("I")
                    .font(.fraunces(18, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("Intashyo AI")
                    .font(.jakarta(15, weight: .bold))
                    .foregroundColor(.ink)
                HStack(spacing: 4) {
                    Circle().fill(Color.appGreen).frame(width: 6, height: 6)
                    Text("\(L.online) · \(L.chatSub)")
                        .font(.jakarta(11, weight: .semibold))
                        .foregroundColor(.appGreen)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Text(appState.selectedLanguage.flag).font(.system(size: 12))
                Text(appState.selectedLanguage.code)
                    .font(.jakarta(12, weight: .semibold))
                    .foregroundColor(.ink)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.cream)
            .cornerRadius(8)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, 12)
    }

    // MARK: - Suggested Prompts

    private var suggestedPrompts: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 8) {
                botAvatar
                VStack(alignment: .leading, spacing: 2) {
                    Text(L.hello)
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundColor(.ink)
                    Text(L.helpPrompt)
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundColor(.ink)
                }
                .padding(14)
                .background(Color.surface)
                .cornerRadius(4, corners: .topLeft)
                .cornerRadius(16, corners: [.topRight, .bottomLeft, .bottomRight])
                .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
                Spacer()
            }

            SectionLabel(text: L.trySuggestions)
                .padding(.top, 4)

            ForEach(Array(L.suggested.enumerated()), id: \.offset) { _, pair in
                Button { sendMessage(pair.0) } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(pair.0)
                            .font(.jakarta(13, weight: .bold))
                            .foregroundColor(.ink)
                        Text(pair.1)
                            .font(.jakarta(12))
                            .foregroundColor(.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.surface)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.faint, lineWidth: 1))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.faint)
            HStack(spacing: 10) {
                HStack {
                    TextField(L.typePlaceholder, text: $inputText, axis: .vertical)
                        .font(.jakarta(14))
                        .focused($inputFocused)
                        .lineLimit(1...4)
                        .onSubmit { sendCurrentMessage() }

                    if inputText.isEmpty {
                        Image(systemName: "mic")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.muted)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.cream)
                .clipShape(Capsule())

                Button { sendCurrentMessage() } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .muted : .white)
                        .frame(width: 44, height: 44)
                        .background(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.faint : Color.accent)
                        .clipShape(Circle())
                        .animation(.easeInOut(duration: 0.2), value: inputText.isEmpty)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, 10)
            .padding(.bottom, 4)
        }
        .background(Color.surface)
    }

    private var botAvatar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accent)
                .frame(width: 28, height: 28)
            Text("I")
                .font(.fraunces(13, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Send

    private func sendCurrentMessage() {
        sendMessage(inputText)
    }

    private func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }
        Haptics.impact(.light)
        errorMessage = nil
        inputText = ""
        let history = messages          // capture history BEFORE appending new message
        messages.append(ChatMessage(role: .user, content: trimmed))
        isLoading = true

        Task {
            do {
                let reply = try await aiService.sendMessage(
                    conversation: history,  // history without the new message
                    userMessage: trimmed,   // new message appended by AIService
                    language: L.aiLanguageName,
                    city: appState.userCity,
                    durationInUS: appState.durationInUS
                )
                isLoading = false
                messages.append(ChatMessage(role: .assistant, content: reply))
                Haptics.success()
            } catch AIError.rateLimited {
                isLoading = false
                errorMessage = "Quota reached — wait 1 min or check aistudio.google.com/app/u/0/apikey"
                Haptics.error()
            } catch AIError.apiError(_, let msg) {
                isLoading = false
                errorMessage = msg
                Haptics.error()
            } catch {
                isLoading = false
                let nsErr = error as NSError
                errorMessage = nsErr.domain == NSURLErrorDomain ? L.errorOffline : L.errorGeneric
                Haptics.error()
            }
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        Group {
            if message.role == .assistant {
                HStack(alignment: .bottom, spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Color.accent).frame(width: 28, height: 28)
                        Text("I").font(.fraunces(13, weight: .bold)).foregroundColor(.white)
                    }
                    Text(message.content)
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundColor(.ink)
                        .padding(14)
                        .background(Color.surface)
                        .cornerRadius(4, corners: .topLeft)
                        .cornerRadius(16, corners: [.topRight, .bottomLeft, .bottomRight])
                        .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    Text(message.content)
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.accent)
                        .cornerRadius(16, corners: [.topLeft, .bottomLeft, .bottomRight])
                        .cornerRadius(4, corners: .topRight)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.78, alignment: .trailing)
                }
            }
        }
    }
}

// MARK: - Typing Bubble

struct TypingBubble: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color.accent).frame(width: 28, height: 28)
                Text("I").font(.fraunces(13, weight: .bold)).foregroundColor(.white)
            }
            TypingIndicator()
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.surface)
                .cornerRadius(4, corners: .topLeft)
                .cornerRadius(16, corners: [.topRight, .bottomLeft, .bottomRight])
                .shadow(color: .black.opacity(0.07), radius: 2, x: 0, y: 1)
            Spacer()
        }
    }
}
