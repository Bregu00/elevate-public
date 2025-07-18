import { Suspense, lazy } from "react";
import { Loading } from "../Loading";
import { SearchBar } from "./Search/SearchBar";
import { getTrackList } from "../../hooks/getTrack";
import { useRecoilState, useRecoilValue, useSetRecoilState } from "recoil";
import { CurrentTab, IsBusy, Lang, MusicList } from "../../reducers/atoms";
import { fetchNui } from "../../hooks/useNuiEvents";

const Home = lazy(() => import("./Home/Home"));
const MainList = lazy(() => import("./MainList/MainList"));

export const Content = () => {
  const lang: any = useRecoilValue(Lang);
  const setMusicList = useSetRecoilState(MusicList);
  const [tab, setTab] = useRecoilState(CurrentTab);
  const [busy, setBusy] = useRecoilState(IsBusy);
  const searchQuery = async (value: string) => {
    if (value == "") {
      setTab({ type: "home", identifier: "" });
      return;
    }
    setBusy(true);
    const resp = await getTrackList(value);
    if (resp) {
      let thumbnail: string = "";
      if (resp && resp[0] && resp[0]["thumbnails"]) {
        thumbnail = resp[0]["thumbnails"][1]
          ? resp[0]["thumbnails"][1]["url"]
          : resp[0]["thumbnails"][0]["url"];
      }
      setMusicList({
        cover: thumbnail || "",
        songs: resp || [],
        name: value || "",
        description: lang.search_results,
      });
      setTab({ type: "results", identifier: "" });
    } else {
      fetchNui("av_laptop", "notification", {
        title: "System Notification",
        message: "Don't use direct links",
        type: "error",
      });
    }
    setBusy(false);
  };

  return (
    <>
      <SearchBar search={searchQuery} />
      {busy ? (
        <Loading />
      ) : (
        <>
          <Suspense fallback={<Loading />}>
            {tab.type == "home" && <Home />}
            {tab.type !== "home" && <MainList />}
          </Suspense>
        </>
      )}
    </>
  );
};
