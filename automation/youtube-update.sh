#!/bin/bash

header_prefix="#### "
placeholder_text="dynamic-channel-data"
output=""

# Convert list of channels into Markdown tables
while read -r line; do
    if [[ ${line} == ${header_prefix}* ]]; then
        echo "Adding header ${line}"
        output="${output}\n${line}\n\n"
        output="${output}| Channel ↕ | # Videos ↕ | Subscribers ↕ | Views ↕ |\n| --- | --- | --- | --- |\n"
    else
        IFS=';' read -r channel_id channel_name emoji <<< "${line}" # Split line by semi-colon
        echo "Adding channel ${channel_name} (${channel_id})"
        curl "https://youtube.googleapis.com/youtube/v3/channels?part=statistics,snippet&id=${channel_id}&key=${API_KEY}" \
            --header 'Accept: application/json' \
            -fsSL -o output.json

        # Pull channel data out of response if possible
        if [[ $(jq -r '.pageInfo.totalResults' output.json) == 1 ]]; then
            title=$(jq -r '.items[0].snippet.title' output.json)
            url=$(jq -r '.items[0].snippet.customUrl' output.json)
            video_count=$(jq -r '.items[0].statistics.videoCount' output.json | numfmt --to=si)
            subscriber_count=$(jq -r '.items[0].statistics.subscriberCount' output.json | numfmt --to=si)
            view_count=$(jq -r '.items[0].statistics.viewCount' output.json | numfmt --to=si)
            echo "Added ${title}: ${video_count} videos (${view_count} views)"
            output="${output}| ${emoji}[${title}](https://youtube.com/${url}) | ${video_count} | ${subscriber_count} | ${view_count} |\n"
        else
            echo "Failed! Bad response received: $(<output.json)"
            exit 1
        fi
    fi
done < "${WORKSPACE}/automation/channels.txt"

# Replace placeholder in template with output, updating the README
template_contents=$(<"${WORKSPACE}/automation/template.md")
echo -e "${template_contents//${placeholder_text}/${output}}" > "${WORKSPACE}/README.md"

# Debug
cat "${WORKSPACE}/README.md"
