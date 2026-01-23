import SwiftUI

struct WrapStack<Item: Hashable, Content: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: (Item) -> Content

    init(items: [Item], spacing: CGFloat = 8, lineSpacing: CGFloat = 8, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.content = content
    }

    var body: some View {
        FlexibleView(availableWidth: UIScreen.main.bounds.width - 64, data: items, spacing: spacing, lineSpacing: lineSpacing, content: content)
    }
}

private struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: (Data.Element) -> Content

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(data), id: \.self) { element in
                content(element)
                    .padding(.trailing, spacing)
                    .padding(.bottom, lineSpacing)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > availableWidth {
                            width = 0
                            height -= dimension.height + lineSpacing
                        }
                        let result = width
                        width -= dimension.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        return result
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
