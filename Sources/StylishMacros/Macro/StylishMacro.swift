//
//  StylishMacro.swift
//
//
//  Created by jsilver on 11/26/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct StylishMacro { }

extension StylishMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let extenstion: DeclSyntax = "extension \(type.trimmed): Stylish { }"
        
        return [
            extenstion
        ]
            .compactMap { $0.as(ExtensionDeclSyntax.self) }
    }
}

extension StylishMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw StylishError("@Stylish can use struct only.")
        }
        
        let accessModifier = structDecl.accessModifier
        let initializer: DeclSyntax = "\(accessModifier)init() { }"
        
        return [
            initializer
        ]
    }
}

extension StylishMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard member.is(VariableDeclSyntax.self) else { return [] }
        
        return [
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(
                    name: .identifier("Config")
                )
            )
        ]
    }
}
