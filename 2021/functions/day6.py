#!/usr/bin/env python3

def main():
    days = 256
    lantern_fish_timers = [int(x) for x in "3,4,3,1,2".split(",")]
    new_fish_each_day = [0] * (days+1)
    fish_alive_each_day = [0] * (days+1)

    # initialize
    # we use the fish we know about, and set their breeding schedule
    fish_alive_each_day[0] = len(lantern_fish_timers)
    for timer in lantern_fish_timers:
        breeding_days = [x+timer+1
                         for x in range(days+1)
                         if x%7 == 0 and x+timer+1 <= days]
        for day in breeding_days:
            new_fish_each_day[day] += 1


    # then we calculate for each remaining day
    for day in range(1, days+1):
        new_fish = new_fish_each_day[day]
        fish_alive_each_day[day] = fish_alive_each_day[day-1] + new_fish
        # new fish breed and produce a new fish after 9 days,
        # and then every 7th day after that
        if day+9 <= days:
            new_fish_each_day[day+9] += new_fish
            breeding_days = [x+1
                            for x in range(day+9, days)
                            if (x-(day+9)+1)%7 == 0]

            for breeding_day in breeding_days:
                new_fish_each_day[breeding_day] += new_fish

    # 26984457539
    print(f"The solution is: {fish_alive_each_day[-1]}")

if __name__ == "__main__":
    main()
