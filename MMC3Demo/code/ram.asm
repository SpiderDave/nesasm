sprite:             .dsb 256

disableInput:       .dsb 1

buffer1Offset:      .dsb 1          ; Offset for buffer1
buffer1:            .dsb 100        ; Buffer to hold data to write to PPU

objectX_hi:         .dsb maxObjects
objectX:            .dsb maxObjects
objectY_hi:         .dsb maxObjects
objectY:            .dsb maxObjects
objectTile:         .dsb maxObjects
objectType:         .dsb maxObjects
objectVelocityX_hi: .dsb maxObjects
objectVelocityX:    .dsb maxObjects
objectVelocityY_hi: .dsb maxObjects
objectVelocityY:    .dsb maxObjects
objectAttributes:   .dsb maxObjects
objectReserved1:    .dsb maxObjects
objectReserved2:    .dsb maxObjects
objectReserved3:    .dsb maxObjects

shootCooldown:      .dsb 1

scrollX_page:       .dsb 1
scrollX_hi:         .dsb 1
scrollX:            .dsb 1
scrollY_hi          .dsb 1
scrollY:            .dsb 1

timer1:             .dsb 1
timer2:             .dsb 1


lives:              .dsb 1
bombs:              .dsb 1

NEA:                .dsb 1