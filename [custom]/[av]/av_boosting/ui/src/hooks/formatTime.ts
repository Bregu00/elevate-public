export const FormatTime = (seconds:number) => {
    if (seconds <= 0 || seconds >= 9000000000) {
        return `N/A`
    } else {
        return new Date(seconds * 1000).toISOString().slice(11, 19)
    }
}