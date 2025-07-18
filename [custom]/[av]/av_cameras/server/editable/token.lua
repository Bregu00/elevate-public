-- Add your Fivemanage or Fivemerr API token(s) here:
photoToken = "" -- used for photos
videoToken = "" -- used for videos

lib.callback.register('av_cameras:getConfig', function(source)
    return {
      token = videoToken,
      service = Config.HostingService
    }
end)