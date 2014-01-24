now = -> Date.now()
Array.prototype.last = -> @[@.length - 1]

hollaback = window.angular.module "hollaback", []

hollaback.controller "HollabackCtrl", ($scope) ->
  $scope._init = ->
    @bpm = 1
    @taps =
      diffs: []
      stamps: []


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



  $scope._init()
