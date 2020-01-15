// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Strings {

  internal enum Home {
    internal enum NavigationBar {
      /// cuHacking
      internal static let title = Strings.tr("CUHacking", "home.navigationBar.title")
    }
    internal enum TabBar {
      /// Home
      internal static let title = Strings.tr("CUHacking", "home.tabBar.title")
    }
  }

  internal enum Information {
    internal enum HeaderCell {
      /// Cereomonies are in RB1234
      internal static let title = Strings.tr("CUHacking", "information.headerCell.title")
    }
  }

  internal enum Map {
    /// L%d
    internal static func level(_ p1: Int) -> String {
      return Strings.tr("CUHacking", "map.level", p1)
    }
    internal enum TabBar {
      /// Map
      internal static let title = Strings.tr("CUHacking", "map.tabBar.title")
    }
  }

  internal enum Schedule {
    internal enum TabBar {
      /// Schedule
      internal static let title = Strings.tr("CUHacking", "schedule.tabBar.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
