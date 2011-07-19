
syn match cp2kKeyword "\s*\w\+\s*" nextgroup=cp2kFollowing
syn match cp2kFollowing ".*"
syn region cp2kKeywordRegion start="^\s*[^!#&]" end="$" contains=cp2kKeyword keepend
syn region cp2kNOKeywordRegion start="^\s*[!#&]" end="$" contains= keepend

hi link cp2kKeyword Identifier
hi link cp2kFollowing Constant
