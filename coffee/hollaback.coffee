resolution = 16

now = -> Date.now()
Array::last = -> @[@length - 1]
Number::msb = ->
  i = 0
  while (1 << i) <= @
    ++i
  i - 1

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
              @finishedNotes.push @AnalyzeBar @curBar
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
      else
        notes.push "/4"
        return if len == 0
        notes.push ":" + len
      transValue = len
      notes.push "X"

    Fill = (start, end, rest = false) ->
      diff = end - start
      if diff == 0
        return []
      sigil = if rest then "r" else ""
      log2 = Math.pow 2, diff.msb()
      if diff == log2
        return [resolution / log2 + sigil]
      if start % log2 != 0
        log2 /= 2
      [resolution / log2 + sigil].concat Fill(start + log2, end, true)

    @finishedNotes = []
    @AnalyzeBar = (bar) ->
      rhythm = []
      remaining = resolution
      while bar.length
        note = bar.pop()
        rhythm = Fill(note, remaining).concat rhythm
        remaining = note
      rhythm.join " "



  $scope._init()
