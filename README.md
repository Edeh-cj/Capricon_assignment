# Capricon's speakprompt

A Flutter app that generates a story from a user prompt, you would have the user input a prompt, make an HTTP request to a story generation API, then send the generated story to a text-to-speech API, retrieve the speech audio, and finally play it out loud. 

Configured for Android alone.

## Issues & Workarounds

I initially explored using OpenAI and Claude for story generation as instructed, but due to pricing and verification issues, I couldn't find a suitable endpoint. Instead, I switched to the free versions of Google's Text-to-Text API for story generation and Speechify's Text-to-Speech API for converting the story to audio, which offered a more accessible solution.

Audio play out was not configured for emulator, works perfectly on real device.
