export const GetThumbnail = (url: any) => {
  const res: any = url.match(/([a-z0-9_-]{11})/gim)[0];
  const thumbnail = `https://img.youtube.com/vi/${res}/0.jpg`;
  return thumbnail;
};

export const GetYoutubeInfo = async (url: any) => {
  const videoIdMatch = url.match(/([a-zA-Z0-9_-]{11})/);
  if (!videoIdMatch) {
    return false;
  }

  const videoId = videoIdMatch[0];
  try {
    const response = await fetch(`https://www.youtube.com/watch?v=${videoId}`);
    if (!response.ok) {
      return false;
    }

    const html = await response.text();
    const ytInitialPlayerResponse = JSON.parse(
      html
        .split("ytInitialPlayerResponse = ")[1]
        .split(`;var meta = document.createElement('meta')`)[0]
    );

    const artist = ytInitialPlayerResponse.videoDetails.author;
    const title = ytInitialPlayerResponse.videoDetails.title;
    const duration = ytInitialPlayerResponse.videoDetails.lengthSeconds;
    const thumbnail = `https://img.youtube.com/vi/${videoId}/0.jpg`;

    return { artist, title, duration, url, thumbnail };
  } catch (error) {
    console.error("Error fetching YouTube video info:", error);
    return false;
  }
};
