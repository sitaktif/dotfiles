" Vim color file
" Converted from Textmate theme Clouds Midnight using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Clouds Midnight"

hi Cursor                         guibg=#7da5dc gui=none
hi Visual                         guibg=#000000 gui=none
hi CursorLine                     guibg=#1f1f1f gui=none
hi CursorColumn                   guibg=#1f1f1f gui=none
hi ColorColumn                    guibg=#1f1f1f gui=none
hi LineNr           guifg=#565656 guibg=#191919 gui=none
hi VertSplit        guifg=#303030 guibg=#303030 gui=none
hi MatchParen       guifg=#927c5d               gui=none
hi StatusLine       guifg=#929292 guibg=#303030 gui=bold
hi StatusLineNC     guifg=#929292 guibg=#303030 gui=none
hi Pmenu                                        gui=none
hi PmenuSel                       guibg=#000000 gui=none
hi IncSearch                      guibg=#413a2f gui=none
hi Search                         guibg=#413a2f gui=none
hi Directory                                    gui=none
hi Folded           guifg=#3c403b guibg=#191919 gui=none

hi Normal           guifg=#929292 guibg=#191919 gui=none
hi Boolean          guifg=#39946a               gui=none
hi Character                                    gui=none
hi Comment          guifg=#3c403b               gui=none
hi Conditional      guifg=#927c5d               gui=none
hi Constant                                     gui=none
hi Define           guifg=#927c5d               gui=none
hi ErrorMsg         guifg=#ffffff guibg=#e92e2e gui=none
hi WarningMsg       guifg=#ffffff guibg=#e92e2e gui=none
hi Float            guifg=#46a609               gui=none
hi Function                                     gui=none
hi Identifier       guifg=#e92e2e               gui=none
hi Keyword          guifg=#927c5d               gui=none
hi Label            guifg=#5d90cd               gui=none
hi NonText          guifg=#333333               gui=none
hi Number           guifg=#46a609               gui=none
hi Operator         guifg=#4b4b4b               gui=none
hi PreProc          guifg=#927c5d               gui=none
hi Special          guifg=#929292               gui=none
hi SpecialKey       guifg=#bfbfbf guibg=#1f1f1f gui=none
hi Statement        guifg=#927c5d               gui=none
hi StorageClass     guifg=#e92e2e               gui=none
hi String           guifg=#5d90cd               gui=none
hi Tag              guifg=#606060               gui=none
hi Title            guifg=#929292               gui=bold
hi Todo             guifg=#3c403b               gui=inverse,bold
hi Type                                         gui=none
hi Underlined                                   gui=underline
hi rubyClass  guifg=#927c5d            gui=none
hi rubyFunction                        gui=none
hi rubyInterpolationDelimiter                        gui=none
hi rubySymbol                        gui=none
hi rubyConstant                        gui=none
hi rubyStringDelimiter  guifg=#5d90cd            gui=none
hi rubyBlockParameter                        gui=none
hi rubyInstanceVariable                        gui=none
hi rubyInclude  guifg=#927c5d            gui=none
hi rubyGlobalVariable                        gui=none
hi rubyRegexp  guifg=#5d90cd            gui=none
hi rubyRegexpDelimiter  guifg=#5d90cd            gui=none
hi rubyEscape                        gui=none
hi rubyControl  guifg=#927c5d            gui=none
hi rubyClassVariable                        gui=none
hi rubyOperator  guifg=#4b4b4b            gui=none
hi rubyException  guifg=#927c5d            gui=none
hi rubyPseudoVariable                        gui=none
hi rubyRailsUserClass                        gui=none
hi rubyRailsARAssociationMethod  guifg=#e92e2e            gui=none
hi rubyRailsARMethod  guifg=#e92e2e            gui=none
hi rubyRailsRenderMethod  guifg=#e92e2e            gui=none
hi rubyRailsMethod  guifg=#e92e2e            gui=none
hi erubyDelimiter  guifg=#e92e2e            gui=none
hi erubyComment  guifg=#3c403b            gui=none
hi erubyRailsMethod  guifg=#e92e2e            gui=none
hi htmlTag                        gui=none
hi htmlEndTag                        gui=none
hi htmlTagName                        gui=none
hi htmlArg                        gui=none
hi htmlSpecialChar  guifg=#a165ac            gui=none
hi javaScriptFunction  guifg=#e92e2e            gui=none
hi javaScriptRailsFunction  guifg=#e92e2e            gui=none
hi javaScriptBraces                        gui=none
hi yamlKey  guifg=#606060            gui=none
hi yamlAnchor                        gui=none
hi yamlAlias                        gui=none
hi yamlDocumentHeader  guifg=#5d90cd            gui=none
hi cssURL                        gui=none
hi cssFunctionName  guifg=#e92e2e            gui=none
hi cssColor  guifg=#a165ac            gui=none
hi cssPseudoClassId  guifg=#606060            gui=none
hi cssClassName  guifg=#e92e2e            gui=none
hi cssValueLength  guifg=#46a609            gui=none
hi cssCommonAttr  guifg=#a165ac            gui=none
hi cssBraces                        gui=none
