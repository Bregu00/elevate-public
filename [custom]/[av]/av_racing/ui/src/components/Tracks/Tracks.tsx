import { useEffect, useState } from "react";
import { Grid, Box } from "@mantine/core";
import { TrackCard } from "./TrackCard";
import { Header } from "./Header";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { ModalLeaderboard } from "./Leaderboard/ModalLeaderboard";
import { GetTrackType } from "../../hooks/getTrackType";
import { useRecoilValue } from "recoil";
import { Lang, Profile } from "../../reducers/atoms";
import { Loading } from "../Loading";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import classes from "./style.module.css";

const Tracks = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [createTracks, setCreateTracks] = useState(false);
  const [deleteTrack, setDeleteTrack] = useState(false);
  const [createRace, setCreateRace] = useState(false);
  const [trackList, setTrackList] = useState([]);
  const [filterCategories, setFilterCategories] = useState([]);
  const [tracksCategories, setTracksCategories] = useState([]);
  const [accounts, setAccounts] = useState([]);
  const { settings } = useRecoilValue(Profile);
  const [tracks, setTracks] = useState(trackList);
  const [showModal, setShowModal] = useState(false);
  const [modalOptions, setModalOptions] = useState({});
  const [showLeaderboard, setShowLeaderboard] = useState(false);
  const [currentLeaderboard, setCurrentLeaderboard] = useState({});
  const [count, setCount] = useState(0);

  const handleSearch = (value: string) => {
    const newGroup = trackList.filter((data: any) => {
      if (value == "") {
        return trackList;
      } else {
        return data.name.toLowerCase().includes(value.toLowerCase());
      }
    });
    setTracks(newGroup);
  };
  const handleFilter = (value: string) => {
    const newGroup = trackList.filter((data: any) => {
      if (value == "all") {
        return trackList;
      } else {
        return data?.type?.toLowerCase().includes(value.toLowerCase());
      }
    });
    setTracks(newGroup);
  };
  const handlePreview = (checkpoints: any) => {
    fetchNui("av_racing", "preview", { checkpoints, settings });
  };
  const createEvent = (track: any) => {
    setModalOptions({
      title: lang.create_event_title,
      options: [
        {
          name: "title",
          icon: "fa-solid fa-file-lines",
          title: lang.event_name,
          type: "text",
          asterisk: true,
        },
        {
          name: "password",
          icon: "fa-solid fa-key",
          title: lang.event_password,
          type: "password",
        },
        {
          name: "startsin",
          icon: "fa-regular fa-clock",
          title: lang.event_startsin,
          type: "number",
          asterisk: true,
        },
        {
          name: "buyin",
          icon: "fa-solid fa-sack-dollar",
          title: lang.event_buyin,
          type: "number",
          asterisk: true,
        },
        {
          name: "moneyAccount",
          icon: "fa-brands fa-ethereum",
          title: lang.account,
          type: "select",
          asterisk: true,
          options: accounts,
        },
        {
          name: "laps",
          icon: "fa-solid fa-flag-checkered",
          title: lang.event_laps,
          type: "number",
          default: 0,
          asterisk: true,
        },
        {
          name: "class",
          title: lang.event_class,
          type: "select",
          asterisk: true,
          max: 1,
          searchable: false,
          options: [
            { value: "all", label: "All" },
            { value: "m", label: "M" },
            { value: "d", label: "D" },
            { value: "c", label: "C" },
            { value: "b", label: "B" },
            { value: "a", label: "A" },
            { value: "a+", label: "A+" },
            { value: "s", label: "S" },
            { value: "s+", label: "S+" },
          ],
        },
        {
          name: "phasing",
          icon: "fa-solid fa-ghost",
          title: lang.phasing,
          type: "select",
          max: 1,
          searchable: false,
          options: [
            { value: "10", label: "10s" },
            { value: "30", label: "30s" },
            { value: "60", label: "60s" },
            { value: "full", label: lang.phasing_on },
          ],
        },
        {
          name: "type",
          title: lang.event_type,
          type: "select",
          asterisk: true,
          searchable: true,
          options: tracksCategories,
        },
        {
          name: "description",
          icon: "fa-regular fa-pen-to-square",
          label: lang.event_description,
          type: "textarea",
          asterisk: false,
        },
      ],
      button: lang.confirm_button,
      extraData: { event: "newRace", track },
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleNew = () => {
    setModalOptions({
      title: lang.create_track,
      options: [
        {
          name: "title",
          title: lang.track_name,
          type: "text",
          asterisk: true,
          span: 5,
        },
        {
          name: "type",
          title: lang.track_type,
          type: "select",
          asterisk: true,
          searchable: true,
          options: tracksCategories,
          span: 5,
        },
        {
          name: "description",
          label: lang.track_description,
          type: "textarea",
          asterisk: true,
          span: 10,
        },
      ],
      button: lang.confirm_button,
      extraData: { event: "createTrack" },
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleCallback = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    fetchNui("av_racing", data.extraData.event, data);
  };
  const handleDelete = (data: any) => {
    const exist = trackList.find((x: any) => x["identifier"] === data);
    if (exist) {
      const newTracks = trackList.filter((x: any) => x["identifier"] !== data);
      setTrackList(newTracks);
      setTracks(newTracks);
      fetchNui("av_racing", "deleteTrack", data);
    }
  };
  const handleLeaderboard = (data: any) => {
    if (data.leaderboard) {
      const newData = JSON.parse(data.leaderboard);
      setCurrentLeaderboard(newData);
      setShowLeaderboard(true);
    } else {
      fetchNui("av_racing", "noRecords");
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getTracks");
      if (resp) {
        setCreateTracks(resp.createTracks);
        setDeleteTrack(resp.deleteTracks);
        setCreateRace(resp.createRaces);
        setTrackList(resp.tracks);
        setTracks(resp.tracks);
        setFilterCategories(resp.filtered);
        setTracksCategories(resp.categories);
        setAccounts(resp.accounts);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  useEffect(() => {
    let availableTracks = 0;
    trackList.forEach((track: any) => {
      if (GetTrackType(track.type, filterCategories)) {
        availableTracks++;
      }
    });
    setCount(availableTracks);
  }, [trackList, filterCategories]);

  if (!loaded) return <Loading />;
  return (
    <>
      {showModal && <ModalMenu data={modalOptions} />}
      {showLeaderboard && (
        <ModalLeaderboard
          data={currentLeaderboard}
          setShowLeaderboard={setShowLeaderboard}
        />
      )}
      <Box p="md">
        <Header
          count={count}
          options={filterCategories}
          handleSearch={handleSearch}
          handleFilter={handleFilter}
          handleNew={handleNew}
          createTracks={createTracks}
        />
        <Grid className={classes.container} mt="md">
          {tracks.map((track: any, index: number) => (
            <>
              {GetTrackType(track.type, filterCategories) ? (
                <Grid.Col span={"auto"} maw={280}>
                  <TrackCard
                    track={track}
                    key={index}
                    lang={lang}
                    deleteTrack={deleteTrack}
                    handleDelete={handleDelete}
                    createRace={createRace}
                    handlePreview={handlePreview}
                    createEvent={createEvent}
                    handleLeaderboard={handleLeaderboard}
                  />
                </Grid.Col>
              ) : null}
            </>
          ))}
        </Grid>
      </Box>
    </>
  );
};

export default Tracks;
