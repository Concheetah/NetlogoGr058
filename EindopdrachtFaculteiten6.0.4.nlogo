patches-own[
  faculteit ; a list of the faculteiten, in numbers
  faculteit-profile    ; a list of the faculty profile (S, T, P)
  faculteit-s ; hoe sociaal de faculteit is
  faculteit-p ; hoeveel prestige de faculteit heeft
  faculteit-t ; hoe hoog het technische/beta gehalte is van de faculteit
  faculteit-letter ; faculty name
  strategie-faculteit ; voorlichtingsstrategie van de faculteit
]

turtles-own[
  student-profile ; a list of the students profile (S, T, P)
  student-s ; hoe sociaal de student is
  student-t ; hoe technische de student is of hoe sterk in de betavakken
  student-p ; hoe belangrijk de student prestige vind
  vrienden ; een lijst met alle turtles die vrienden zijn
  strategie-student ; keuzestrategie van de student (rationeel, snob, feestbeest of ambitieus)
  max-vrienden-bereikt? ; true/false
  student-faculteit
  happiness-S ; hoe gelukkig de student is in sociaal opzicht
  happiness-T ; hoe gelukkig de student is academisch
  happiness-P ; hoe gelukkig de student is met de prestige van de opleiding
  happiness ; hoe gelukkig de student is in het algemeen
  mood
  happy
  unhappy
  positief
  negatief

]

globals [
  faculteit-boundaries ; a list of faculteiten definitions, where each faculteit is a list of its min pxcor and max pxcor
  faculteit-letters    ; a list of the faculty letters
  studenten-aantal     ; aantal studenten totaal
  studenten-faculteit-aantal ; aantal studenten op een faculteit
  dl ; learning-score per college, die student krijgt per keer dat hij/zij naar college gaat
  naar-college-gaan
  average-score
  learning-score ; totale learning-score
  basis-kans-factor
  te-veel-vrienden-factor
  max-vrienden-happiness



]

to setup
  clear-all
  setup-faculteiten 4
  setup-studenten              ;; dit moet in go wanneer de one-day procedure klaar is
  ;test
  show "hello"
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;; Faculteiten procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; aangepaste many regions example [regions vervangen door faculteiten]
to setup-faculteiten [num-faculteiten]
  foreach faculteiten-divisions num-faculteiten draw-faculteit-division
  set faculteit-boundaries calculate-faculteit-boundaries num-faculteiten
  let faculteit-numbers (range 1 (num-faculteiten + 1))
  (foreach faculteit-boundaries faculteit-numbers [ [boundaries faculteit-number] ->
    ask patches with [ pxcor >= first boundaries and pxcor <= last boundaries ] [
      set faculteit faculteit-number
    ]
  ])
  ask patches with [faculteit = 1][
    set faculteit-letter "A"
    set faculteit-profile [8 2 2]
    set pcolor 14
    set strategie-faculteit "honest"
    set faculteit-s (item 0 faculteit-profile)
    set faculteit-t (item 1 faculteit-profile)
    set faculteit-p (item 2 faculteit-profile)
  ]
  ask patches with [faculteit = 2][
    set faculteit-letter "B"
    set faculteit-profile [2 8 3]
    set pcolor 34
    set strategie-faculteit "honest"
    set faculteit-s (item 0 faculteit-profile)
    set faculteit-t (item 1 faculteit-profile)
    set faculteit-p (item 2 faculteit-profile)
  ]
  ask patches with [faculteit = 3][
    set faculteit-letter "C"
    set faculteit-profile [2 8 8]
    set pcolor 44
    set strategie-faculteit "honest"
    set faculteit-s (item 0 faculteit-profile)
    set faculteit-t (item 1 faculteit-profile)
    set faculteit-p (item 2 faculteit-profile)
  ]
  ask patches with [faculteit = 4][
    set faculteit-letter "D"
    set faculteit-profile [5 5 9]
    set pcolor 84
    set strategie-faculteit "honest"
    set faculteit-s (item 0 faculteit-profile)
    set faculteit-t (item 1 faculteit-profile)
    set faculteit-p (item 2 faculteit-profile)
  ]
end

; many regions example
to draw-faculteit-division [ x ]
  ask patches with [ pxcor = x ] [
    set pcolor grey + 1.5
  ]
  create-turtles 1 [
    ; use a temporary turtle to draw a line in the middle of our division
    setxy x max-pycor + 0.5
    set heading 0
    set color grey - 3
    pen-down
    forward world-height
    set xcor xcor + 1 / patch-size
    right 180
    set color grey + 3
    forward world-height
    die ; our turtle has done its job and is no longer needed
  ]
end

; many regions example
to-report faculteiten-divisions [ num-faculteits ]
  report n-values (num-faculteits + 1) [ n ->
    [ pxcor ] of patch (min-pxcor + (n * ((max-pxcor - min-pxcor) / num-faculteits))) 0
  ]
end

; many regions example
to-report calculate-faculteit-boundaries [ num-faculteits ]
  let divisions faculteiten-divisions num-faculteits
  report (map [ [d1 d2] -> list (d1 + 1) (d2 - 1) ] (but-last divisions) (but-first divisions))
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; go procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  ; setup-studenten

  ; studiekeuze

  ; one-day procedure:
  ; move students
  ask turtles [if max-vrienden-bereikt? = false [move-students]] ; alleen bewegen als max-vrienden niet is bereikt
  ; naar college gaan
  vrienden-maken
  test

  ; einde van het jaar
  ; feedback
  ; studenten studeren af
  tick
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; studenten procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup-studenten
  ; studenten worden random verdeeld over de faculteiten
  set studenten-aantal 0
  ask n-of 300 patches with [faculteit-letter != 0][
  sprout 1
  [
    set studenten-aantal (studenten-aantal + 1)
    set shape "person"
    ; random getallen tussen 1 en 10 genereren voor de S, T en P waardes van de student
    set student-profile ["S" "T" "P"]
    set student-profile (map [a -> (random 9 + 1)] student-profile)                    ; willekeurig profiel toekennen aan elke student
    set student-s (item 0 student-profile)
    set student-t (item 1 student-profile)
    set student-p (item 2 student-profile)
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Learning score @Milou?
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Happiness score @Milou?
    keuzestrategie-student
    set vrienden []
    set max-vrienden-bereikt? false
    set student-faculteit ([faculteit-letter] of patch-here)
   ;   if (keuzestrategie = "Rationeel") [move-to ]
  if (keuzestrategie = "Feestbeest") [move-to max-one-of patches with [faculteit-letter != 0][item 0 faculteit-profile]]
  if (keuzestrategie = "Ambitieus") [move-to max-one-of patches with [faculteit-letter != 0] [item 1 faculteit-profile]]
  if (keuzestrategie = "Snob") [move-to max-one-of patches with [faculteit-letter != 0] [item 2 faculteit-profile]]
  ]]
    ; er moet hier nog iets gebeuren met het vergelijken van de keuzestrategie van de student & voorlichtingsstrategie faculteit
end

; studenten bewegen door de faculteit
to move-students
  ;[ aangepaste versie van de Look ahead example]

        ifelse [faculteit-letter] of patch-ahead 1 = 0    ; als 1 patch verder, de grens van de faculteit is, draait de student zich linksom.
      [ lt random-float 360 ]
      [
      ; we kijken welke faculteit de student zich bevind en of ze zich sneller gaan bewegen (om meer medestudenten tegen te komen) of minder
      let s-faculteit (range 1 11 1)
      let speed-student (range 0 1 0.1)
      let index (position first ([faculteit-profile] of patch-here) s-faculteit)
      fd (precision (item index speed-student) 1)
      ]

end

to keuzestrategie-student
  ifelse (keuzestrategie = "Rationeel")
        [set color green
         set strategie-student "Rationeel"][
     ifelse (keuzestrategie = "Feestbeest")
        [set color red
          set strategie-student "Feestbeest"][
     ifelse (keuzestrategie = "Ambitieus")
        [set color blue
         set strategie-student "Ambitieus"][
     ifelse (keuzestrategie = "Snob")
        [set color yellow
         ][
     if (keuzestrategie = "Mixed")
        [
        ;75 studenten worden groen
         if studenten-aantal <= 75 [set color green set strategie-student "Rationeel"]
        ;75 studenten worden rood
         if studenten-aantal <= 150 and studenten-aantal > 75 [set color red set strategie-student "Feestbeest"]
        ;75 studenten worden blauw
         if studenten-aantal <= 225 and studenten-aantal > 150 [set color blue set strategie-student "Ambitieus"]
        ;75 studenten worden geel
         if studenten-aantal <= 300 and studenten-aantal > 225 [set color yellow set strategie-student "Snob"]]
    ]]]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; on-day procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to vrienden-maken
;vraag studenten of ze nog vrienden kunnen maken
;max-aantal-vrienden bereikt?
ask turtles[
if (length vrienden != max-vrienden) and (any? other turtles-here with [max-vrienden-bereikt? = false]) ; gebaseerd op partners example
[
      let potentiele-vriend one-of turtles-here ; dit moet nog met de maximale s-waarde op de patch van de turtles gecombineerd worden
      if  member? potentiele-vriend vrienden = false[
        set vrienden (fput potentiele-vriend vrienden)
       ; ask first vrienden [set vrienden (fput myself vrienden)
        ]
      ]

;voeg student toe aan beide vriendenlijsten
    if length vrienden = max-vrienden [set max-vrienden-bereikt? true]
  ]

end

to basis-kans
show count studenten-faculteit-aantal
;show totale student-t
;set average-score ( totale student-t / studenten-faculteit-aantal)
ifelse average-score >= student-t  [set basis-kans-factor 1 - ((average-score - student-t )/ 10)][set basis-kans-factor 1 - ((student-t - average-score) / 10)]
end

to te-veel-vrienden
show count vrienden
ifelse vrienden >= max-friends [set te-veel-vrienden-factor 1]       ;; max-friends = max-vrienden?
[ set te-veel-vrienden-factor (vrienden / max-friends)]            ;; vrienden / max-friends anders defineren
end

to college
set naar-college-gaan  (random 100 < (((1 - te-veel-vrienden-factor) * basis-kans-factor) * 100))       ;; vind iets anders dan set, set heeft twee inputs nodig
end

to learn
set dl ((student-t + faculteit-t) / 20)
print dl
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; scores procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to social-happy
show count vrienden
set max-vrienden-happiness (student-s * 6)
set happiness-S (vrienden / max-vrienden-happiness)
end

to learning-happy
ifelse student-t > 5 and faculteit-t > student-t [set happiness-T (faculteit-t / 5 - 0.5)][set happiness-T ( faculteit-t / 10 * 0.5)]
end

to prestige-happy
set happiness-P ((student-p + faculteit-p) / 20)
end

to happy-overall
set happiness (((happiness-S + happiness-T + happiness-P) / 3) * 100 )
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; uitslag procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to be-happy
ifelse happiness >= unhappiness [set mood happy][set mood unhappy]
end

to be-positief
show count naar-college-gaan                                     ;; check of het lukt om alle keren te tellen dat student naar college gaat met de code
set learning-score (dl * naar-college-gaan)
print learning-score
ifelse learning-score >= learning-score-min [set learning-score positief][set learning-score negatief]
end

;to pass to next year                                      ;; hier gaat nog iets mis
;set doorstroom ( turtles with [happy][positief])
;end

;to rendement
;set rendement (doorstroom / tot-students-faculteit)
;end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; feedback procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;   TESTING   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; here are all the test functions for checking the behavior of the model thusfar

to test
;  test-faculties
;  test-setup-studenten
 ;test-move-studenten
end

to test-faculties
  ask one-of patches with [faculteit-letter = "A"] [
    output-print faculteit-letter
    output-print faculteit-profile
    output-print strategie-faculteit]
  ask one-of patches with [faculteit-letter = "B"] [
    output-print faculteit-letter
    output-print faculteit-profile
    output-print strategie-faculteit]
  ask one-of patches with [faculteit-letter = "C"] [
    output-print faculteit-letter
    output-print faculteit-profile
    output-print strategie-faculteit]
  ask one-of patches with [faculteit-letter = "D"] [
    output-print faculteit-letter
    output-print faculteit-profile
    output-print strategie-faculteit]
end

to test-setup-studenten
  ask turtles [output-print student-profile]
end

to test-move-studenten
  if ticks > 100 [ask turtles with [max-vrienden-bereikt? = true][output-print vrienden]]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
57
78
120
111
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
49
135
192
334
11

BUTTON
130
78
193
111
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
72
352
147
385
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
699
33
837
78
keuzestrategie
keuzestrategie
"Rationeel" "Feestbeest" "Ambitieus" "Snob" "Mixed"
4

SLIDER
67
497
239
530
max-vrienden
max-vrienden
0
60
55.0
1
1
NIL
HORIZONTAL

PLOT
705
425
905
575
max-vrienden-per-faculteit
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -5298144 true "" "plot count turtles with [max-vrienden-bereikt? = true and student-faculteit = \"A\"]"
"pen-2" 1.0 0 -8431303 true "" "plot count turtles with [max-vrienden-bereikt? = true and student-faculteit = \"B\"]"
"pen-3" 1.0 0 -4079321 true "" "plot count turtles with [max-vrienden-bereikt? = true and student-faculteit = \"C\"]"
"pen-4" 1.0 0 -12345184 true "" "plot count turtles with [max-vrienden-bereikt? = true and student-faculteit = \"D\"]"

SLIDER
889
122
1061
155
max-friends
max-friends
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
888
168
1060
201
unhappiness
unhappiness
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
889
218
1061
251
learning-score-min
learning-score-min
0
20
10.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

Parts of the code are copied of Many Regions Example.

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
