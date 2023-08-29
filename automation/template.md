## The List™️

The List™️ contains all official Yogscast YouTube channels, as well as any unofficial clip / compilation channels!

It updates once a day (see [how it works](#how-it-works)), if you know any additional channels please [add them](#adding-channel) (or [ask me to](mailto:jake@jakelee.co.uk)). 

Tap a table's header to sort by that field, the best-of-the-best have a little Pickaxe (⛏️) next to them.

### Channels
dynamic-channel-data

## How it works

### Updating

This list updates once per day with the latest stats for each channel. Full details [are available here](https://blog.jakelee.co.uk/fetching-youtube-metadata-in-github-actions-and-persisting/).

### Adding channel

To add a channel, edit [`channels.txt`](https://github.com/JakeSteam/Yogscast/blob/main/automation/channels.txt) to include the channel ID, channel name, and a ⛏️ if it's a truly impressive channel:
* Channel ID can be retrieved from a profile at `About` -> `Share` -> `Copy channel ID`
* Channel name is not used, except to make the file more readable.

<script>
window.onload = function() {
    // Pull value out of the cell we're comparing
    const getCellValue = (tr, idx) => idx === 0 ? 
        tr.children[idx].textContent : 
        parseFormattedInt(tr.children[idx].textContent);

    // Convert formatted number into sortable numeric one
    function parseFormattedInt(formattedInt) {
        if (formattedInt.includes(".")) {
            return formattedInt
                .replace(".", "")
                .replace("K", "00")
                .replace("M", "00000")
                .replace("B", "00000000");
        } else {
            return formattedInt
                .replace("K", "000")
                .replace("M", "000000")
                .replace("B", "000000000");
        };
    };

    // Compare function for each cell's value
    const comparer = (idx, asc) => (a, b) => ((v1, v2) =>
        v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

    // Make clicking a header sort the contents
    document.querySelectorAll('th').forEach(th => th.addEventListener('click', (() => {
        const table = th.closest('table');
        const tbody = table.querySelector('tbody');
        Array.from(tbody.querySelectorAll('tr'))
            .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
            .forEach(tr => tbody.appendChild(tr));
    })));
}
</script>
