# Safari: load injected.js as a MAIN world content script

## Problem
In Safari the extension loads but never shows the settings button or the glow.
The console shows:

    Refused to load safari-web-extension://.../scripts/injected.js because it does
    not appear in the script-src directive of the Content Security Policy.

content.js injects `<script src=chrome.runtime.getURL('scripts/injected.js')>`
into the page, and YouTube's CSP blocks the `safari-web-extension:` scheme.
Because that load fails, content-main.js is never imported either.

## Fix
Register injected.js in the manifest as a content script with `"world": "MAIN"`
(same match patterns as content.js) and drop the `<script>` tag injection.
injected.js doesn't read any attributes from its own script tag, and it talks to
content.js through events, so nothing else changes.

## Tested
Safari on macOS (Xcode project from safari-web-extension-converter): settings
button and ambient glow work on youtube.com watch pages.

## Not tested / questions
- Chrome: `world` in manifest content_scripts needs Chrome 111+ (you require 121).
- Firefox: manifest `world: "MAIN"` needs Firefox 128+, but gecko
  strict_min_version is 121. You may want to keep the script-tag path for
  Firefox, or bump the minimum. Happy to adjust the PR to whatever you prefer.
- I only tested the watch page, not embeds or live chat.
