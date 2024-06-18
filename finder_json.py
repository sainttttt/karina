
header = """
{
    "description": "Regular key disable Finder",
    "manipulators": [
    """

template = """
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com.apple.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "#"
            },
            "to": [
                {
                    "key_code": "vk_none"
                }
            ],
            "type": "basic"
        },

        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com.apple.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "#",
                "modifiers": {
                    "mandatory": [
                        "shift"
                    ]
                }
            },
            "to": [
                {
                    "key_code": "#"
                }
            ],
            "type": "basic"
        }
    """
footer = """

    ]
}
"""
out = ""
out += header
for l in "abcdefghijklmnopqrstuvwxyz":
    out += template.replace("#", l)
    if l != "z":
        out += ","

out += footer
with open("finder.json", 'w') as f:
    f.write(out)
