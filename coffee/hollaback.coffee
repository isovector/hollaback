resolution = 32

now = -> Date.now()
Array.prototype.last = -> @[@length - 1]

hollaback = window.angular.module "hollaback", []

hollaback.controller "HollabackCtrl", ($scope) ->
  $scope._init = ->
    # time signature
    @beatsPerBar = 4
    @beatValue = 4

    # tempo
    @bpm = 1
    @taps =
      diffs: []
      stamps: []

    # rhythm
    @sampleRate = 1000
    @sampleCount = 0
    @curBar = null


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
              @curBar = []
            setTimeout timeout, @sampleRate
            @$apply()
        )()

      @curBar.push @sampleCount



  $scope._init()
