resolution = 16

now = -> Date.now()
Array.prototype.last = -> @[@length - 1]

hollaback = window.angular.module "hollaback", []

hollaback.controller "HollabackCtrl", ($scope) ->
  $scope._init = ->
    # time signature
    @beatsPerBar = 4
    @beatValue = 4

    # tempo
    @bpm = 96
    @taps =
      diffs: []
      stamps: []

    # rhythm
    @sampleRate = 78
    @sampleCount = 0
    @curBar = null
    @bars = []

    # transcription


    @ResetBpm = ->
      @taps.diffs = []
      @taps.stamps = []


    @TapBpm = ->
      stamp = now()
      @taps.diffs.push stamp - @taps.stamps.last() if @taps.stamps.length
      @taps.stamps.push stamp

      if @taps.diffs.length > 1
        @bpm = Math.round 60000 * @taps.diffs.length /
          @taps.diffs.reduce (x, item) ->
            x + item
          , 0
        @sampleRate =
          Math.round 1000 / (@bpm * resolution / @beatValue / 60)


    @TapRhythm = ->
      unless @curBar?
        @curBar = []
        (
          timeout = =>
            @sampleCount++
            if @sampleCount == resolution
              @sampleCount = 0
              @bars.push @curBar
              @finishedNotes.push (@AnalyzeBar @curBar).join " "
              @curBar = []
            setTimeout timeout, @sampleRate
            @$apply()
        )()

      @curBar.push @sampleCount

    notes = []
    transValue = 0
    Emit = (len, rest = false) ->
      if len == transValue
        notes.push "-"
      else if len == 0
        notes.push "/4"
        return
      else
        notes.push ":" + len
      transValue = len
      notes.push "X"

    @finishedNotes = []
    @AnalyzeBar = (bar) ->
      cur = bar[0]
      for beat in [1..bar.length]
        next = bar[beat]
        diff = next - cur
        size = Math.round resolution / diff
        Emit size
        cur = next
      Emit 0
      mynotes = notes
      notes = []
      mynotes



  $scope._init()
