//
//  TestAsync.swift
//  OnlyBoostiOS
//
//  Created by Niko Giraud on 3/20/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct TestAsync: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://i.imgur.com/XyvrE7X.png"))
    }
}

#Preview {
    TestAsync()
}
