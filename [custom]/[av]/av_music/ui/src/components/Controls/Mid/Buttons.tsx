import { Group, rem, ActionIcon } from "@mantine/core";
import {
  IconPlayerSkipBackFilled,
  IconPlayerSkipForwardFilled,
  IconPlayerPlayFilled,
  IconPlayerPauseFilled,
  IconArrowsShuffle,
  IconRepeat,
} from "@tabler/icons-react";
import { useRecoilState, useRecoilValue } from "recoil";
import { CurrentSong, MusicList, PlayerStatus } from "../../../reducers/atoms";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "../style.module.css";

export const Buttons = () => {
  const musicList = useRecoilValue(MusicList);
  const song = useRecoilValue(CurrentSong);
  const [player, setPlayer] = useRecoilState(PlayerStatus);

  const iconStyle = {
    width: rem(20),
    height: rem(20),
    cursor: "pointer",
  };

  const handlePlay = () => {
    if (player.headphones) return;
    if (!player.loaded && song.url !== "") {
      const copy = { ...song, volume: player.volume };
      fetchNui("av_music", "play", { song: copy, playlist: musicList.songs });
      return;
    }
    fetchNui("av_music", "togglePlay", !player.playing);
    const copy = { ...player, playing: !player.playing };
    setPlayer(copy);
  };

  const handleLoop = () => {
    if (player.headphones) return;
    const copy = { ...player, loop: !player.loop };
    setPlayer(copy);
    fetchNui("av_music", "loop", !player.loop);
  };
  const handleShuffle = () => {
    if (player.headphones) return;
    const copy = { ...player, shuffle: !player.shuffle };
    setPlayer(copy);
    fetchNui("av_music", "shuffle", !player.shuffle);
  };

  return (
    <>
      <Group className={classes.buttons}>
        <ActionIcon
          className={classes.control}
          radius={20}
          variant="transparent"
          color={player.shuffle ? `#fa5252` : `rgb(128,128,128)`}
          onClick={handleShuffle}
        >
          <IconArrowsShuffle
            style={{
              height: rem(14),
              width: rem(14),

              cursor: "pointer",
            }}
          />
        </ActionIcon>
        <ActionIcon
          className={classes.control}
          radius={20}
          variant="transparent"
          color="gray"
          onClick={() => {
            fetchNui("av_music", "previous");
          }}
        >
          <IconPlayerSkipBackFilled style={iconStyle} />
        </ActionIcon>
        <ActionIcon
          className={classes.control}
          onClick={() => {
            handlePlay();
          }}
          radius={50}
          size="xl"
          variant="transparent"
          color={player.playing ? "#fa5252" : "gray"}
          style={{
            border: player.playing
              ? "solid 1.55px rgb(250,82,82)"
              : "solid 1.55px gray",
            cursor: "pointer",
          }}
        >
          {player.playing ? (
            <IconPlayerPauseFilled />
          ) : (
            <IconPlayerPlayFilled />
          )}
        </ActionIcon>
        <ActionIcon
          className={classes.control}
          radius={20}
          variant="transparent"
          color="gray"
          onClick={() => {
            fetchNui("av_music", "next");
          }}
        >
          <IconPlayerSkipForwardFilled style={iconStyle} />
        </ActionIcon>
        <ActionIcon
          className={classes.control}
          radius={20}
          variant="transparent"
          color={player.loop ? `#fa5252` : `rgb(128,128,128)`}
          onClick={handleLoop}
        >
          <IconRepeat style={{ width: rem(14), height: rem(14) }} />
        </ActionIcon>
      </Group>
    </>
  );
};
