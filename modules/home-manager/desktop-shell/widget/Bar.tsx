import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import Battery from "gi://AstalBattery"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("00:00", 1000, (_) => {
    const now = new Date();
    const hours = now.getHours() % 12 !== 0 ? now.getHours() % 12 : 12;
    const minutes = now.getMinutes();
    const ampm = now.getHours() < 12 ? "AM" : "PM";
    return `${hours}:${minutes} ${ampm}`;
  })
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="end" cssName="control-center">
          <levelbar value={0.5} widthRequest={200} />
          <label label={time} />
          <label label={Battery.get_default()} />
        </box>
      </centerbox>
    </window>
  )
}
