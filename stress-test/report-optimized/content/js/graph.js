/*
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
$(document).ready(function() {

    $(".click-title").mouseenter( function(    e){
        e.preventDefault();
        this.style.cursor="pointer";
    });
    $(".click-title").mousedown( function(event){
        event.preventDefault();
    });

    // Ugly code while this script is shared among several pages
    try{
        refreshHitsPerSecond(true);
    } catch(e){}
    try{
        refreshResponseTimeOverTime(true);
    } catch(e){}
    try{
        refreshResponseTimePercentiles();
    } catch(e){}
});


var responseTimePercentilesInfos = {
        data: {"result": {"minY": 37.0, "minX": 0.0, "maxY": 2821.0, "series": [{"data": [[0.0, 37.0], [0.1, 56.0], [0.2, 65.0], [0.3, 73.0], [0.4, 77.0], [0.5, 81.0], [0.6, 86.0], [0.7, 88.0], [0.8, 90.0], [0.9, 93.0], [1.0, 94.0], [1.1, 97.0], [1.2, 98.0], [1.3, 102.0], [1.4, 103.0], [1.5, 104.0], [1.6, 107.0], [1.7, 108.0], [1.8, 109.0], [1.9, 111.0], [2.0, 114.0], [2.1, 115.0], [2.2, 118.0], [2.3, 120.0], [2.4, 121.0], [2.5, 122.0], [2.6, 124.0], [2.7, 125.0], [2.8, 128.0], [2.9, 129.0], [3.0, 130.0], [3.1, 131.0], [3.2, 132.0], [3.3, 133.0], [3.4, 134.0], [3.5, 136.0], [3.6, 137.0], [3.7, 138.0], [3.8, 139.0], [3.9, 140.0], [4.0, 141.0], [4.1, 142.0], [4.2, 143.0], [4.3, 143.0], [4.4, 144.0], [4.5, 146.0], [4.6, 147.0], [4.7, 147.0], [4.8, 148.0], [4.9, 149.0], [5.0, 150.0], [5.1, 152.0], [5.2, 153.0], [5.3, 154.0], [5.4, 155.0], [5.5, 156.0], [5.6, 157.0], [5.7, 158.0], [5.8, 158.0], [5.9, 159.0], [6.0, 159.0], [6.1, 160.0], [6.2, 161.0], [6.3, 162.0], [6.4, 163.0], [6.5, 164.0], [6.6, 164.0], [6.7, 165.0], [6.8, 165.0], [6.9, 166.0], [7.0, 166.0], [7.1, 167.0], [7.2, 168.0], [7.3, 169.0], [7.4, 169.0], [7.5, 170.0], [7.6, 171.0], [7.7, 171.0], [7.8, 172.0], [7.9, 173.0], [8.0, 174.0], [8.1, 175.0], [8.2, 175.0], [8.3, 177.0], [8.4, 177.0], [8.5, 178.0], [8.6, 179.0], [8.7, 179.0], [8.8, 180.0], [8.9, 181.0], [9.0, 182.0], [9.1, 182.0], [9.2, 182.0], [9.3, 183.0], [9.4, 183.0], [9.5, 184.0], [9.6, 184.0], [9.7, 185.0], [9.8, 185.0], [9.9, 186.0], [10.0, 186.0], [10.1, 187.0], [10.2, 188.0], [10.3, 188.0], [10.4, 189.0], [10.5, 190.0], [10.6, 190.0], [10.7, 191.0], [10.8, 192.0], [10.9, 193.0], [11.0, 193.0], [11.1, 193.0], [11.2, 194.0], [11.3, 194.0], [11.4, 194.0], [11.5, 195.0], [11.6, 196.0], [11.7, 196.0], [11.8, 196.0], [11.9, 197.0], [12.0, 197.0], [12.1, 197.0], [12.2, 198.0], [12.3, 198.0], [12.4, 199.0], [12.5, 199.0], [12.6, 199.0], [12.7, 200.0], [12.8, 200.0], [12.9, 200.0], [13.0, 201.0], [13.1, 202.0], [13.2, 203.0], [13.3, 203.0], [13.4, 203.0], [13.5, 204.0], [13.6, 204.0], [13.7, 204.0], [13.8, 205.0], [13.9, 205.0], [14.0, 206.0], [14.1, 207.0], [14.2, 207.0], [14.3, 208.0], [14.4, 209.0], [14.5, 209.0], [14.6, 209.0], [14.7, 210.0], [14.8, 210.0], [14.9, 211.0], [15.0, 212.0], [15.1, 212.0], [15.2, 213.0], [15.3, 213.0], [15.4, 213.0], [15.5, 214.0], [15.6, 214.0], [15.7, 214.0], [15.8, 215.0], [15.9, 215.0], [16.0, 216.0], [16.1, 216.0], [16.2, 216.0], [16.3, 217.0], [16.4, 217.0], [16.5, 218.0], [16.6, 219.0], [16.7, 219.0], [16.8, 219.0], [16.9, 220.0], [17.0, 220.0], [17.1, 220.0], [17.2, 220.0], [17.3, 221.0], [17.4, 221.0], [17.5, 222.0], [17.6, 222.0], [17.7, 223.0], [17.8, 223.0], [17.9, 224.0], [18.0, 224.0], [18.1, 224.0], [18.2, 225.0], [18.3, 225.0], [18.4, 226.0], [18.5, 226.0], [18.6, 226.0], [18.7, 226.0], [18.8, 227.0], [18.9, 227.0], [19.0, 227.0], [19.1, 228.0], [19.2, 228.0], [19.3, 229.0], [19.4, 229.0], [19.5, 229.0], [19.6, 229.0], [19.7, 230.0], [19.8, 230.0], [19.9, 230.0], [20.0, 230.0], [20.1, 231.0], [20.2, 231.0], [20.3, 232.0], [20.4, 232.0], [20.5, 232.0], [20.6, 233.0], [20.7, 233.0], [20.8, 234.0], [20.9, 234.0], [21.0, 234.0], [21.1, 235.0], [21.2, 235.0], [21.3, 235.0], [21.4, 236.0], [21.5, 236.0], [21.6, 237.0], [21.7, 237.0], [21.8, 238.0], [21.9, 238.0], [22.0, 239.0], [22.1, 239.0], [22.2, 240.0], [22.3, 240.0], [22.4, 240.0], [22.5, 241.0], [22.6, 242.0], [22.7, 242.0], [22.8, 242.0], [22.9, 242.0], [23.0, 243.0], [23.1, 243.0], [23.2, 243.0], [23.3, 244.0], [23.4, 244.0], [23.5, 245.0], [23.6, 245.0], [23.7, 245.0], [23.8, 245.0], [23.9, 245.0], [24.0, 246.0], [24.1, 246.0], [24.2, 247.0], [24.3, 247.0], [24.4, 247.0], [24.5, 247.0], [24.6, 248.0], [24.7, 248.0], [24.8, 249.0], [24.9, 249.0], [25.0, 249.0], [25.1, 250.0], [25.2, 250.0], [25.3, 250.0], [25.4, 251.0], [25.5, 251.0], [25.6, 251.0], [25.7, 252.0], [25.8, 252.0], [25.9, 252.0], [26.0, 252.0], [26.1, 253.0], [26.2, 253.0], [26.3, 253.0], [26.4, 253.0], [26.5, 254.0], [26.6, 254.0], [26.7, 255.0], [26.8, 255.0], [26.9, 255.0], [27.0, 255.0], [27.1, 256.0], [27.2, 256.0], [27.3, 256.0], [27.4, 257.0], [27.5, 257.0], [27.6, 257.0], [27.7, 258.0], [27.8, 258.0], [27.9, 259.0], [28.0, 259.0], [28.1, 259.0], [28.2, 260.0], [28.3, 260.0], [28.4, 260.0], [28.5, 261.0], [28.6, 262.0], [28.7, 262.0], [28.8, 262.0], [28.9, 263.0], [29.0, 264.0], [29.1, 264.0], [29.2, 264.0], [29.3, 264.0], [29.4, 265.0], [29.5, 265.0], [29.6, 265.0], [29.7, 266.0], [29.8, 266.0], [29.9, 266.0], [30.0, 266.0], [30.1, 267.0], [30.2, 267.0], [30.3, 267.0], [30.4, 268.0], [30.5, 268.0], [30.6, 268.0], [30.7, 268.0], [30.8, 269.0], [30.9, 269.0], [31.0, 269.0], [31.1, 270.0], [31.2, 270.0], [31.3, 270.0], [31.4, 271.0], [31.5, 271.0], [31.6, 271.0], [31.7, 271.0], [31.8, 272.0], [31.9, 272.0], [32.0, 272.0], [32.1, 273.0], [32.2, 273.0], [32.3, 274.0], [32.4, 274.0], [32.5, 275.0], [32.6, 275.0], [32.7, 275.0], [32.8, 275.0], [32.9, 276.0], [33.0, 276.0], [33.1, 276.0], [33.2, 277.0], [33.3, 277.0], [33.4, 277.0], [33.5, 277.0], [33.6, 278.0], [33.7, 278.0], [33.8, 279.0], [33.9, 279.0], [34.0, 280.0], [34.1, 280.0], [34.2, 280.0], [34.3, 280.0], [34.4, 281.0], [34.5, 281.0], [34.6, 281.0], [34.7, 281.0], [34.8, 282.0], [34.9, 282.0], [35.0, 282.0], [35.1, 282.0], [35.2, 283.0], [35.3, 283.0], [35.4, 283.0], [35.5, 284.0], [35.6, 284.0], [35.7, 284.0], [35.8, 285.0], [35.9, 285.0], [36.0, 286.0], [36.1, 286.0], [36.2, 286.0], [36.3, 287.0], [36.4, 287.0], [36.5, 287.0], [36.6, 287.0], [36.7, 288.0], [36.8, 288.0], [36.9, 288.0], [37.0, 288.0], [37.1, 289.0], [37.2, 290.0], [37.3, 290.0], [37.4, 290.0], [37.5, 290.0], [37.6, 291.0], [37.7, 291.0], [37.8, 291.0], [37.9, 291.0], [38.0, 291.0], [38.1, 292.0], [38.2, 292.0], [38.3, 293.0], [38.4, 293.0], [38.5, 293.0], [38.6, 294.0], [38.7, 294.0], [38.8, 294.0], [38.9, 294.0], [39.0, 295.0], [39.1, 295.0], [39.2, 295.0], [39.3, 296.0], [39.4, 296.0], [39.5, 297.0], [39.6, 297.0], [39.7, 297.0], [39.8, 298.0], [39.9, 298.0], [40.0, 298.0], [40.1, 299.0], [40.2, 299.0], [40.3, 299.0], [40.4, 299.0], [40.5, 299.0], [40.6, 300.0], [40.7, 300.0], [40.8, 300.0], [40.9, 301.0], [41.0, 301.0], [41.1, 301.0], [41.2, 302.0], [41.3, 302.0], [41.4, 302.0], [41.5, 303.0], [41.6, 303.0], [41.7, 303.0], [41.8, 304.0], [41.9, 304.0], [42.0, 304.0], [42.1, 305.0], [42.2, 305.0], [42.3, 305.0], [42.4, 305.0], [42.5, 306.0], [42.6, 306.0], [42.7, 306.0], [42.8, 306.0], [42.9, 307.0], [43.0, 307.0], [43.1, 307.0], [43.2, 308.0], [43.3, 308.0], [43.4, 309.0], [43.5, 309.0], [43.6, 309.0], [43.7, 309.0], [43.8, 310.0], [43.9, 310.0], [44.0, 310.0], [44.1, 311.0], [44.2, 311.0], [44.3, 311.0], [44.4, 312.0], [44.5, 312.0], [44.6, 312.0], [44.7, 313.0], [44.8, 313.0], [44.9, 313.0], [45.0, 314.0], [45.1, 314.0], [45.2, 314.0], [45.3, 314.0], [45.4, 315.0], [45.5, 315.0], [45.6, 315.0], [45.7, 315.0], [45.8, 316.0], [45.9, 316.0], [46.0, 316.0], [46.1, 317.0], [46.2, 317.0], [46.3, 317.0], [46.4, 318.0], [46.5, 318.0], [46.6, 318.0], [46.7, 318.0], [46.8, 319.0], [46.9, 319.0], [47.0, 320.0], [47.1, 320.0], [47.2, 321.0], [47.3, 321.0], [47.4, 321.0], [47.5, 322.0], [47.6, 322.0], [47.7, 322.0], [47.8, 323.0], [47.9, 323.0], [48.0, 323.0], [48.1, 323.0], [48.2, 324.0], [48.3, 324.0], [48.4, 325.0], [48.5, 325.0], [48.6, 325.0], [48.7, 326.0], [48.8, 326.0], [48.9, 326.0], [49.0, 327.0], [49.1, 327.0], [49.2, 328.0], [49.3, 328.0], [49.4, 329.0], [49.5, 329.0], [49.6, 329.0], [49.7, 330.0], [49.8, 330.0], [49.9, 330.0], [50.0, 331.0], [50.1, 331.0], [50.2, 332.0], [50.3, 332.0], [50.4, 332.0], [50.5, 333.0], [50.6, 333.0], [50.7, 333.0], [50.8, 334.0], [50.9, 334.0], [51.0, 335.0], [51.1, 335.0], [51.2, 335.0], [51.3, 336.0], [51.4, 336.0], [51.5, 337.0], [51.6, 337.0], [51.7, 338.0], [51.8, 338.0], [51.9, 339.0], [52.0, 339.0], [52.1, 340.0], [52.2, 340.0], [52.3, 341.0], [52.4, 341.0], [52.5, 342.0], [52.6, 342.0], [52.7, 342.0], [52.8, 343.0], [52.9, 343.0], [53.0, 343.0], [53.1, 343.0], [53.2, 344.0], [53.3, 344.0], [53.4, 344.0], [53.5, 344.0], [53.6, 345.0], [53.7, 345.0], [53.8, 345.0], [53.9, 346.0], [54.0, 346.0], [54.1, 346.0], [54.2, 346.0], [54.3, 347.0], [54.4, 347.0], [54.5, 348.0], [54.6, 348.0], [54.7, 348.0], [54.8, 349.0], [54.9, 349.0], [55.0, 349.0], [55.1, 350.0], [55.2, 350.0], [55.3, 351.0], [55.4, 351.0], [55.5, 352.0], [55.6, 352.0], [55.7, 352.0], [55.8, 353.0], [55.9, 353.0], [56.0, 353.0], [56.1, 354.0], [56.2, 355.0], [56.3, 355.0], [56.4, 355.0], [56.5, 355.0], [56.6, 356.0], [56.7, 356.0], [56.8, 356.0], [56.9, 357.0], [57.0, 357.0], [57.1, 358.0], [57.2, 358.0], [57.3, 358.0], [57.4, 359.0], [57.5, 359.0], [57.6, 360.0], [57.7, 360.0], [57.8, 360.0], [57.9, 361.0], [58.0, 361.0], [58.1, 362.0], [58.2, 362.0], [58.3, 362.0], [58.4, 363.0], [58.5, 363.0], [58.6, 363.0], [58.7, 364.0], [58.8, 364.0], [58.9, 364.0], [59.0, 365.0], [59.1, 366.0], [59.2, 366.0], [59.3, 367.0], [59.4, 367.0], [59.5, 368.0], [59.6, 368.0], [59.7, 368.0], [59.8, 368.0], [59.9, 369.0], [60.0, 369.0], [60.1, 370.0], [60.2, 370.0], [60.3, 370.0], [60.4, 371.0], [60.5, 371.0], [60.6, 372.0], [60.7, 372.0], [60.8, 372.0], [60.9, 373.0], [61.0, 373.0], [61.1, 373.0], [61.2, 373.0], [61.3, 374.0], [61.4, 374.0], [61.5, 375.0], [61.6, 375.0], [61.7, 376.0], [61.8, 376.0], [61.9, 377.0], [62.0, 377.0], [62.1, 378.0], [62.2, 378.0], [62.3, 379.0], [62.4, 379.0], [62.5, 379.0], [62.6, 380.0], [62.7, 381.0], [62.8, 381.0], [62.9, 382.0], [63.0, 382.0], [63.1, 382.0], [63.2, 383.0], [63.3, 383.0], [63.4, 384.0], [63.5, 384.0], [63.6, 384.0], [63.7, 385.0], [63.8, 386.0], [63.9, 386.0], [64.0, 387.0], [64.1, 387.0], [64.2, 388.0], [64.3, 388.0], [64.4, 389.0], [64.5, 389.0], [64.6, 389.0], [64.7, 390.0], [64.8, 390.0], [64.9, 390.0], [65.0, 391.0], [65.1, 391.0], [65.2, 392.0], [65.3, 392.0], [65.4, 393.0], [65.5, 394.0], [65.6, 394.0], [65.7, 395.0], [65.8, 395.0], [65.9, 396.0], [66.0, 396.0], [66.1, 396.0], [66.2, 397.0], [66.3, 397.0], [66.4, 398.0], [66.5, 398.0], [66.6, 399.0], [66.7, 399.0], [66.8, 400.0], [66.9, 401.0], [67.0, 402.0], [67.1, 402.0], [67.2, 403.0], [67.3, 403.0], [67.4, 404.0], [67.5, 404.0], [67.6, 405.0], [67.7, 405.0], [67.8, 406.0], [67.9, 406.0], [68.0, 407.0], [68.1, 407.0], [68.2, 408.0], [68.3, 408.0], [68.4, 409.0], [68.5, 409.0], [68.6, 410.0], [68.7, 410.0], [68.8, 411.0], [68.9, 411.0], [69.0, 412.0], [69.1, 412.0], [69.2, 413.0], [69.3, 413.0], [69.4, 414.0], [69.5, 415.0], [69.6, 415.0], [69.7, 416.0], [69.8, 416.0], [69.9, 417.0], [70.0, 417.0], [70.1, 418.0], [70.2, 419.0], [70.3, 419.0], [70.4, 420.0], [70.5, 420.0], [70.6, 421.0], [70.7, 421.0], [70.8, 422.0], [70.9, 423.0], [71.0, 424.0], [71.1, 425.0], [71.2, 425.0], [71.3, 426.0], [71.4, 426.0], [71.5, 427.0], [71.6, 428.0], [71.7, 429.0], [71.8, 429.0], [71.9, 430.0], [72.0, 430.0], [72.1, 431.0], [72.2, 432.0], [72.3, 432.0], [72.4, 433.0], [72.5, 434.0], [72.6, 435.0], [72.7, 436.0], [72.8, 436.0], [72.9, 437.0], [73.0, 438.0], [73.1, 438.0], [73.2, 439.0], [73.3, 440.0], [73.4, 441.0], [73.5, 442.0], [73.6, 443.0], [73.7, 444.0], [73.8, 444.0], [73.9, 446.0], [74.0, 447.0], [74.1, 448.0], [74.2, 448.0], [74.3, 449.0], [74.4, 450.0], [74.5, 451.0], [74.6, 452.0], [74.7, 452.0], [74.8, 453.0], [74.9, 453.0], [75.0, 454.0], [75.1, 455.0], [75.2, 455.0], [75.3, 457.0], [75.4, 458.0], [75.5, 458.0], [75.6, 460.0], [75.7, 462.0], [75.8, 462.0], [75.9, 463.0], [76.0, 464.0], [76.1, 465.0], [76.2, 466.0], [76.3, 466.0], [76.4, 467.0], [76.5, 468.0], [76.6, 469.0], [76.7, 469.0], [76.8, 470.0], [76.9, 471.0], [77.0, 472.0], [77.1, 473.0], [77.2, 474.0], [77.3, 475.0], [77.4, 475.0], [77.5, 478.0], [77.6, 479.0], [77.7, 480.0], [77.8, 481.0], [77.9, 481.0], [78.0, 482.0], [78.1, 483.0], [78.2, 484.0], [78.3, 485.0], [78.4, 486.0], [78.5, 487.0], [78.6, 488.0], [78.7, 489.0], [78.8, 491.0], [78.9, 493.0], [79.0, 494.0], [79.1, 495.0], [79.2, 496.0], [79.3, 497.0], [79.4, 499.0], [79.5, 500.0], [79.6, 502.0], [79.7, 503.0], [79.8, 504.0], [79.9, 506.0], [80.0, 508.0], [80.1, 511.0], [80.2, 513.0], [80.3, 514.0], [80.4, 516.0], [80.5, 520.0], [80.6, 521.0], [80.7, 522.0], [80.8, 524.0], [80.9, 526.0], [81.0, 528.0], [81.1, 529.0], [81.2, 531.0], [81.3, 534.0], [81.4, 536.0], [81.5, 537.0], [81.6, 538.0], [81.7, 541.0], [81.8, 543.0], [81.9, 545.0], [82.0, 547.0], [82.1, 548.0], [82.2, 549.0], [82.3, 551.0], [82.4, 553.0], [82.5, 555.0], [82.6, 557.0], [82.7, 559.0], [82.8, 559.0], [82.9, 560.0], [83.0, 561.0], [83.1, 562.0], [83.2, 563.0], [83.3, 565.0], [83.4, 566.0], [83.5, 568.0], [83.6, 569.0], [83.7, 572.0], [83.8, 573.0], [83.9, 576.0], [84.0, 578.0], [84.1, 579.0], [84.2, 580.0], [84.3, 582.0], [84.4, 584.0], [84.5, 587.0], [84.6, 588.0], [84.7, 589.0], [84.8, 592.0], [84.9, 595.0], [85.0, 597.0], [85.1, 598.0], [85.2, 599.0], [85.3, 601.0], [85.4, 602.0], [85.5, 605.0], [85.6, 605.0], [85.7, 608.0], [85.8, 611.0], [85.9, 613.0], [86.0, 614.0], [86.1, 617.0], [86.2, 620.0], [86.3, 624.0], [86.4, 625.0], [86.5, 626.0], [86.6, 630.0], [86.7, 632.0], [86.8, 632.0], [86.9, 634.0], [87.0, 635.0], [87.1, 636.0], [87.2, 639.0], [87.3, 640.0], [87.4, 641.0], [87.5, 645.0], [87.6, 646.0], [87.7, 647.0], [87.8, 648.0], [87.9, 650.0], [88.0, 651.0], [88.1, 653.0], [88.2, 655.0], [88.3, 658.0], [88.4, 661.0], [88.5, 663.0], [88.6, 665.0], [88.7, 669.0], [88.8, 670.0], [88.9, 672.0], [89.0, 672.0], [89.1, 674.0], [89.2, 676.0], [89.3, 678.0], [89.4, 681.0], [89.5, 683.0], [89.6, 683.0], [89.7, 686.0], [89.8, 687.0], [89.9, 688.0], [90.0, 691.0], [90.1, 693.0], [90.2, 698.0], [90.3, 700.0], [90.4, 705.0], [90.5, 707.0], [90.6, 710.0], [90.7, 713.0], [90.8, 716.0], [90.9, 721.0], [91.0, 723.0], [91.1, 726.0], [91.2, 728.0], [91.3, 730.0], [91.4, 734.0], [91.5, 736.0], [91.6, 739.0], [91.7, 741.0], [91.8, 745.0], [91.9, 749.0], [92.0, 752.0], [92.1, 756.0], [92.2, 762.0], [92.3, 765.0], [92.4, 768.0], [92.5, 776.0], [92.6, 786.0], [92.7, 789.0], [92.8, 795.0], [92.9, 800.0], [93.0, 805.0], [93.1, 810.0], [93.2, 818.0], [93.3, 826.0], [93.4, 830.0], [93.5, 835.0], [93.6, 843.0], [93.7, 848.0], [93.8, 860.0], [93.9, 868.0], [94.0, 879.0], [94.1, 889.0], [94.2, 895.0], [94.3, 911.0], [94.4, 918.0], [94.5, 927.0], [94.6, 935.0], [94.7, 944.0], [94.8, 949.0], [94.9, 958.0], [95.0, 974.0], [95.1, 984.0], [95.2, 993.0], [95.3, 1013.0], [95.4, 1044.0], [95.5, 1089.0], [95.6, 1121.0], [95.7, 1134.0], [95.8, 1148.0], [95.9, 1204.0], [96.0, 1491.0], [96.1, 1528.0], [96.2, 1550.0], [96.3, 1616.0], [96.4, 1653.0], [96.5, 1716.0], [96.6, 1735.0], [96.7, 1748.0], [96.8, 1769.0], [96.9, 1786.0], [97.0, 1800.0], [97.1, 1802.0], [97.2, 1815.0], [97.3, 1822.0], [97.4, 1833.0], [97.5, 1842.0], [97.6, 1857.0], [97.7, 1865.0], [97.8, 1879.0], [97.9, 1908.0], [98.0, 1918.0], [98.1, 1940.0], [98.2, 1973.0], [98.3, 2008.0], [98.4, 2067.0], [98.5, 2079.0], [98.6, 2098.0], [98.7, 2136.0], [98.8, 2161.0], [98.9, 2212.0], [99.0, 2248.0], [99.1, 2371.0], [99.2, 2428.0], [99.3, 2491.0], [99.4, 2525.0], [99.5, 2536.0], [99.6, 2572.0], [99.7, 2619.0], [99.8, 2650.0], [99.9, 2797.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 100.0, "title": "Response Time Percentiles"}},
        getOptions: function() {
            return {
                series: {
                    points: { show: false }
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendResponseTimePercentiles'
                },
                xaxis: {
                    tickDecimals: 1,
                    axisLabel: "Percentiles",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Percentile value in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : %x.2 percentile was %y ms"
                },
                selection: { mode: "xy" },
            };
        },
        createGraph: function() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesResponseTimePercentiles"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotResponseTimesPercentiles"), dataset, options);
            // setup overview
            $.plot($("#overviewResponseTimesPercentiles"), dataset, prepareOverviewOptions(options));
        }
};

/**
 * @param elementId Id of element where we display message
 */
function setEmptyGraph(elementId) {
    $(function() {
        $(elementId).text("No graph series with filter="+seriesFilter);
    });
}

// Response times percentiles
function refreshResponseTimePercentiles() {
    var infos = responseTimePercentilesInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyResponseTimePercentiles");
        return;
    }
    if (isGraph($("#flotResponseTimesPercentiles"))){
        infos.createGraph();
    } else {
        var choiceContainer = $("#choicesResponseTimePercentiles");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotResponseTimesPercentiles", "#overviewResponseTimesPercentiles");
        $('#bodyResponseTimePercentiles .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
}

var responseTimeDistributionInfos = {
        data: {"result": {"minY": 1.0, "minX": 0.0, "maxY": 1392.0, "series": [{"data": [[0.0, 62.0], [600.0, 253.0], [700.0, 130.0], [800.0, 67.0], [900.0, 51.0], [1000.0, 14.0], [1100.0, 19.0], [1200.0, 2.0], [1300.0, 1.0], [1400.0, 4.0], [1500.0, 13.0], [100.0, 572.0], [1600.0, 10.0], [1700.0, 26.0], [1800.0, 44.0], [1900.0, 20.0], [2000.0, 18.0], [2100.0, 13.0], [2200.0, 10.0], [2300.0, 2.0], [2400.0, 9.0], [2500.0, 18.0], [2600.0, 8.0], [2800.0, 4.0], [2700.0, 4.0], [200.0, 1392.0], [300.0, 1310.0], [400.0, 634.0], [500.0, 290.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 100, "maxX": 2800.0, "title": "Response Time Distribution"}},
        getOptions: function() {
            var granularity = this.data.result.granularity;
            return {
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendResponseTimeDistribution'
                },
                xaxis:{
                    axisLabel: "Response times in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of responses",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                bars : {
                    show: true,
                    barWidth: this.data.result.granularity
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: function(label, xval, yval, flotItem){
                        return yval + " responses for " + label + " were between " + xval + " and " + (xval + granularity) + " ms";
                    }
                }
            };
        },
        createGraph: function() {
            var data = this.data;
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotResponseTimeDistribution"), prepareData(data.result.series, $("#choicesResponseTimeDistribution")), options);
        }

};

// Response time distribution
function refreshResponseTimeDistribution() {
    var infos = responseTimeDistributionInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyResponseTimeDistribution");
        return;
    }
    if (isGraph($("#flotResponseTimeDistribution"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesResponseTimeDistribution");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        $('#footerResponseTimeDistribution .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};


var syntheticResponseTimeDistributionInfos = {
        data: {"result": {"minY": 10.0, "minX": 0.0, "ticks": [[0, "Requests having \nresponse time <= 500ms"], [1, "Requests having \nresponse time > 500ms and <= 1,500ms"], [2, "Requests having \nresponse time > 1,500ms"], [3, "Requests in error"]], "maxY": 4900.0, "series": [{"data": [[0.0, 90.0]], "color": "#9ACD32", "isOverall": false, "label": "Requests having \nresponse time <= 500ms", "isController": false}, {"data": [[1.0, 10.0]], "color": "yellow", "isOverall": false, "label": "Requests having \nresponse time > 500ms and <= 1,500ms", "isController": false}, {"data": [], "color": "orange", "isOverall": false, "label": "Requests having \nresponse time > 1,500ms", "isController": false}, {"data": [[3.0, 4900.0]], "color": "#FF6347", "isOverall": false, "label": "Requests in error", "isController": false}], "supportsControllersDiscrimination": false, "maxX": 3.0, "title": "Synthetic Response Times Distribution"}},
        getOptions: function() {
            return {
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendSyntheticResponseTimeDistribution'
                },
                xaxis:{
                    axisLabel: "Response times ranges",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                    tickLength:0,
                    min:-0.5,
                    max:3.5
                },
                yaxis: {
                    axisLabel: "Number of responses",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                bars : {
                    show: true,
                    align: "center",
                    barWidth: 0.25,
                    fill:.75
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: function(label, xval, yval, flotItem){
                        return yval + " " + label;
                    }
                }
            };
        },
        createGraph: function() {
            var data = this.data;
            var options = this.getOptions();
            prepareOptions(options, data);
            options.xaxis.ticks = data.result.ticks;
            $.plot($("#flotSyntheticResponseTimeDistribution"), prepareData(data.result.series, $("#choicesSyntheticResponseTimeDistribution")), options);
        }

};

// Response time distribution
function refreshSyntheticResponseTimeDistribution() {
    var infos = syntheticResponseTimeDistributionInfos;
    prepareSeries(infos.data, true);
    if (isGraph($("#flotSyntheticResponseTimeDistribution"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesSyntheticResponseTimeDistribution");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        $('#footerSyntheticResponseTimeDistribution .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var activeThreadsOverTimeInfos = {
        data: {"result": {"minY": 86.27480000000013, "minX": 1.78883814E12, "maxY": 86.27480000000013, "series": [{"data": [[1.78883814E12, 86.27480000000013]], "isOverall": false, "label": "Seckill Rush", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883814E12, "title": "Active Threads Over Time"}},
        getOptions: function() {
            return {
                series: {
                    stack: true,
                    lines: {
                        show: true,
                        fill: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of active threads",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                legend: {
                    noColumns: 6,
                    show: true,
                    container: '#legendActiveThreadsOverTime'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                selection: {
                    mode: 'xy'
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : At %x there were %y active threads"
                }
            };
        },
        createGraph: function() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesActiveThreadsOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotActiveThreadsOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewActiveThreadsOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Active Threads Over Time
function refreshActiveThreadsOverTime(fixTimestamps) {
    var infos = activeThreadsOverTimeInfos;
    prepareSeries(infos.data);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotActiveThreadsOverTime"))) {
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesActiveThreadsOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotActiveThreadsOverTime", "#overviewActiveThreadsOverTime");
        $('#footerActiveThreadsOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var timeVsThreadsInfos = {
        data: {"result": {"minY": 43.0, "minX": 1.0, "maxY": 819.0, "series": [{"data": [[2.0, 318.0], [3.0, 43.0], [4.0, 54.2], [5.0, 177.5], [6.0, 56.0], [7.0, 60.0], [8.0, 537.5], [9.0, 819.0], [10.0, 313.0], [11.0, 249.0], [12.0, 424.8333333333333], [13.0, 586.0], [14.0, 597.6666666666666], [15.0, 587.0], [16.0, 579.5], [17.0, 496.12500000000006], [18.0, 210.0], [19.0, 145.0], [20.0, 113.0], [21.0, 161.85714285714286], [22.0, 167.8], [23.0, 110.16666666666667], [24.0, 150.79999999999998], [25.0, 134.0909090909091], [26.0, 181.63636363636363], [27.0, 171.22222222222223], [28.0, 167.625], [29.0, 176.0], [30.0, 134.0], [31.0, 228.0], [32.0, 133.75], [33.0, 186.76923076923077], [34.0, 180.9666666666666], [35.0, 149.7241379310345], [36.0, 190.23529411764707], [37.0, 156.58333333333331], [38.0, 160.18750000000003], [39.0, 199.55555555555554], [40.0, 207.875], [41.0, 469.3793103448275], [42.0, 326.2058823529412], [43.0, 338.87499999999994], [44.0, 193.41666666666663], [45.0, 187.33333333333331], [46.0, 191.91666666666666], [47.0, 167.95238095238096], [48.0, 243.64285714285708], [49.0, 285.0], [50.0, 214.22222222222223], [51.0, 228.10714285714286], [52.0, 195.56250000000003], [53.0, 187.3684210526316], [54.0, 226.50000000000006], [55.0, 216.67647058823528], [56.0, 220.0526315789473], [57.0, 211.08333333333334], [59.0, 266.88235294117646], [58.0, 202.5], [60.0, 214.87500000000003], [61.0, 262.578947368421], [62.0, 210.5757575757576], [63.0, 243.49999999999997], [64.0, 298.95454545454544], [65.0, 250.56], [66.0, 296.91304347826093], [67.0, 280.93333333333334], [68.0, 273.12500000000006], [69.0, 237.625], [70.0, 253.15789473684208], [71.0, 225.20000000000002], [72.0, 240.6], [73.0, 246.38461538461527], [74.0, 276.25000000000006], [75.0, 251.40909090909093], [76.0, 248.77272727272728], [77.0, 248.74074074074076], [78.0, 243.53846153846155], [79.0, 252.35000000000005], [80.0, 258.41666666666663], [81.0, 266.3548387096775], [82.0, 301.2105263157894], [83.0, 265.59375000000006], [84.0, 276.9750000000001], [85.0, 283.8857142857143], [86.0, 289.76923076923083], [87.0, 298.14814814814815], [88.0, 271.6], [89.0, 280.20000000000005], [90.0, 283.796875], [91.0, 285.24999999999994], [92.0, 299.00000000000006], [93.0, 314.96610169491527], [94.0, 297.34883720930225], [95.0, 299.0666666666667], [96.0, 284.92857142857144], [97.0, 274.73333333333335], [98.0, 326.57746478873247], [99.0, 387.4], [100.0, 546.2100757326308], [1.0, 562.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}, {"data": [[86.27480000000013, 431.8427999999992]], "isOverall": false, "label": "POST /api/seckill-Aggregated", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 100.0, "title": "Time VS Threads"}},
        getOptions: function() {
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    axisLabel: "Number of active threads",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Average response times in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                legend: { noColumns: 2,show: true, container: '#legendTimeVsThreads' },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s: At %x.2 active threads, Average response time was %y.2 ms"
                }
            };
        },
        createGraph: function() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesTimeVsThreads"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotTimesVsThreads"), dataset, options);
            // setup overview
            $.plot($("#overviewTimesVsThreads"), dataset, prepareOverviewOptions(options));
        }
};

// Time vs threads
function refreshTimeVsThreads(){
    var infos = timeVsThreadsInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyTimeVsThreads");
        return;
    }
    if(isGraph($("#flotTimesVsThreads"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesTimeVsThreads");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotTimesVsThreads", "#overviewTimesVsThreads");
        $('#footerTimeVsThreads .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var bytesThroughputOverTimeInfos = {
        data : {"result": {"minY": 32940.0, "minX": 1.78883814E12, "maxY": 43565.0, "series": [{"data": [[1.78883814E12, 43565.0]], "isOverall": false, "label": "Bytes received per second", "isController": false}, {"data": [[1.78883814E12, 32940.0]], "isOverall": false, "label": "Bytes sent per second", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883814E12, "title": "Bytes Throughput Over Time"}},
        getOptions : function(){
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity) ,
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Bytes / sec",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendBytesThroughputOverTime'
                },
                selection: {
                    mode: "xy"
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s at %x was %y"
                }
            };
        },
        createGraph : function() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesBytesThroughputOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotBytesThroughputOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewBytesThroughputOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Bytes throughput Over Time
function refreshBytesThroughputOverTime(fixTimestamps) {
    var infos = bytesThroughputOverTimeInfos;
    prepareSeries(infos.data);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotBytesThroughputOverTime"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesBytesThroughputOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotBytesThroughputOverTime", "#overviewBytesThroughputOverTime");
        $('#footerBytesThroughputOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
}

var responseTimesOverTimeInfos = {
        data: {"result": {"minY": 431.8427999999992, "minX": 1.78883814E12, "maxY": 431.8427999999992, "series": [{"data": [[1.78883814E12, 431.8427999999992]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883814E12, "title": "Response Time Over Time"}},
        getOptions: function(){
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Average response time in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendResponseTimesOverTime'
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : at %x Average response time was %y ms"
                }
            };
        },
        createGraph: function() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesResponseTimesOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotResponseTimesOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewResponseTimesOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Response Times Over Time
function refreshResponseTimeOverTime(fixTimestamps) {
    var infos = responseTimesOverTimeInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyResponseTimeOverTime");
        return;
    }
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotResponseTimesOverTime"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesResponseTimesOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotResponseTimesOverTime", "#overviewResponseTimesOverTime");
        $('#footerResponseTimesOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var latenciesOverTimeInfos = {
        data: {"result": {"minY": 383.02780000000007, "minX": 1.78883814E12, "maxY": 383.02780000000007, "series": [{"data": [[1.78883814E12, 383.02780000000007]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883814E12, "title": "Latencies Over Time"}},
        getOptions: function() {
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Average response latencies in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendLatenciesOverTime'
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : at %x Average latency was %y ms"
                }
            };
        },
        createGraph: function () {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesLatenciesOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotLatenciesOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewLatenciesOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Latencies Over Time
function refreshLatenciesOverTime(fixTimestamps) {
    var infos = latenciesOverTimeInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyLatenciesOverTime");
        return;
    }
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotLatenciesOverTime"))) {
        infos.createGraph();
    }else {
        var choiceContainer = $("#choicesLatenciesOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotLatenciesOverTime", "#overviewLatenciesOverTime");
        $('#footerLatenciesOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var connectTimeOverTimeInfos = {
        data: {"result": {"minY": 0.9467999999999993, "minX": 1.78883814E12, "maxY": 0.9467999999999993, "series": [{"data": [[1.78883814E12, 0.9467999999999993]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883814E12, "title": "Connect Time Over Time"}},
        getOptions: function() {
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getConnectTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Average Connect Time in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendConnectTimeOverTime'
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : at %x Average connect time was %y ms"
                }
            };
        },
        createGraph: function () {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesConnectTimeOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotConnectTimeOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewConnectTimeOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Connect Time Over Time
function refreshConnectTimeOverTime(fixTimestamps) {
    var infos = connectTimeOverTimeInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyConnectTimeOverTime");
        return;
    }
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotConnectTimeOverTime"))) {
        infos.createGraph();
    }else {
        var choiceContainer = $("#choicesConnectTimeOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotConnectTimeOverTime", "#overviewConnectTimeOverTime");
        $('#footerConnectTimeOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var responseTimePercentilesOverTimeInfos = {
        data: {"result": {"minY": 93.0, "minX": 1.78883814E12, "maxY": 707.0, "series": [{"data": [[1.78883814E12, 707.0]], "isOverall": false, "label": "Max", "isController": false}, {"data": [[1.78883814E12, 519.1000000000004]], "isOverall": false, "label": "90th percentile", "isController": false}, {"data": [[1.78883814E12, 706.9499999999999]], "isOverall": false, "label": "99th percentile", "isController": false}, {"data": [[1.78883814E12, 622.8499999999992]], "isOverall": false, "label": "95th percentile", "isController": false}, {"data": [[1.78883814E12, 93.0]], "isOverall": false, "label": "Min", "isController": false}, {"data": [[1.78883814E12, 215.5]], "isOverall": false, "label": "Median", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883814E12, "title": "Response Time Percentiles Over Time (successful requests only)"}},
        getOptions: function() {
            return {
                series: {
                    lines: {
                        show: true,
                        fill: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Response Time in ms",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: '#legendResponseTimePercentilesOverTime'
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s : at %x Response time was %y ms"
                }
            };
        },
        createGraph: function () {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesResponseTimePercentilesOverTime"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotResponseTimePercentilesOverTime"), dataset, options);
            // setup overview
            $.plot($("#overviewResponseTimePercentilesOverTime"), dataset, prepareOverviewOptions(options));
        }
};

// Response Time Percentiles Over Time
function refreshResponseTimePercentilesOverTime(fixTimestamps) {
    var infos = responseTimePercentilesOverTimeInfos;
    prepareSeries(infos.data);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotResponseTimePercentilesOverTime"))) {
        infos.createGraph();
    }else {
        var choiceContainer = $("#choicesResponseTimePercentilesOverTime");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotResponseTimePercentilesOverTime", "#overviewResponseTimePercentilesOverTime");
        $('#footerResponseTimePercentilesOverTime .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};


var responseTimeVsRequestInfos = {
    data: {"result": {"minY": 138.0, "minX": 1.0, "maxY": 2090.0, "series": [{"data": [[80.0, 189.0], [181.0, 312.5]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[36.0, 315.5], [39.0, 1688.0], [51.0, 995.0], [108.0, 596.0], [112.0, 666.5], [132.0, 2090.0], [157.0, 561.0], [10.0, 2027.5], [169.0, 732.0], [174.0, 138.0], [181.0, 197.0], [190.0, 398.0], [221.0, 259.0], [236.0, 189.5], [241.0, 373.0], [249.0, 414.0], [256.0, 404.0], [260.0, 388.5], [1.0, 562.0], [279.0, 265.0], [286.0, 323.5], [302.0, 330.5], [290.0, 390.5], [306.0, 271.0], [328.0, 281.5]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 328.0, "title": "Response Time Vs Request"}},
    getOptions: function() {
        return {
            series: {
                lines: {
                    show: false
                },
                points: {
                    show: true
                }
            },
            xaxis: {
                axisLabel: "Global number of requests per second",
                axisLabelUseCanvas: true,
                axisLabelFontSizePixels: 12,
                axisLabelFontFamily: 'Verdana, Arial',
                axisLabelPadding: 20,
            },
            yaxis: {
                axisLabel: "Median Response Time in ms",
                axisLabelUseCanvas: true,
                axisLabelFontSizePixels: 12,
                axisLabelFontFamily: 'Verdana, Arial',
                axisLabelPadding: 20,
            },
            legend: {
                noColumns: 2,
                show: true,
                container: '#legendResponseTimeVsRequest'
            },
            selection: {
                mode: 'xy'
            },
            grid: {
                hoverable: true // IMPORTANT! this is needed for tooltip to work
            },
            tooltip: true,
            tooltipOpts: {
                content: "%s : Median response time at %x req/s was %y ms"
            },
            colors: ["#9ACD32", "#FF6347"]
        };
    },
    createGraph: function () {
        var data = this.data;
        var dataset = prepareData(data.result.series, $("#choicesResponseTimeVsRequest"));
        var options = this.getOptions();
        prepareOptions(options, data);
        $.plot($("#flotResponseTimeVsRequest"), dataset, options);
        // setup overview
        $.plot($("#overviewResponseTimeVsRequest"), dataset, prepareOverviewOptions(options));

    }
};

// Response Time vs Request
function refreshResponseTimeVsRequest() {
    var infos = responseTimeVsRequestInfos;
    prepareSeries(infos.data);
    if (isGraph($("#flotResponseTimeVsRequest"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesResponseTimeVsRequest");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotResponseTimeVsRequest", "#overviewResponseTimeVsRequest");
        $('#footerResponseRimeVsRequest .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};


var latenciesVsRequestInfos = {
    data: {"result": {"minY": 61.0, "minX": 1.0, "maxY": 1905.0, "series": [{"data": [[80.0, 175.5], [181.0, 305.5]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[36.0, 298.0], [39.0, 1586.0], [51.0, 859.0], [108.0, 575.0], [112.0, 594.0], [132.0, 1905.0], [157.0, 506.0], [10.0, 947.5], [169.0, 626.0], [174.0, 121.5], [181.0, 178.0], [190.0, 371.5], [221.0, 225.0], [236.0, 169.0], [241.0, 344.0], [249.0, 376.0], [256.0, 353.5], [260.0, 344.5], [1.0, 61.0], [279.0, 238.0], [286.0, 298.0], [302.0, 297.0], [290.0, 343.5], [306.0, 246.5], [328.0, 255.0]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 328.0, "title": "Latencies Vs Request"}},
    getOptions: function() {
        return{
            series: {
                lines: {
                    show: false
                },
                points: {
                    show: true
                }
            },
            xaxis: {
                axisLabel: "Global number of requests per second",
                axisLabelUseCanvas: true,
                axisLabelFontSizePixels: 12,
                axisLabelFontFamily: 'Verdana, Arial',
                axisLabelPadding: 20,
            },
            yaxis: {
                axisLabel: "Median Latency in ms",
                axisLabelUseCanvas: true,
                axisLabelFontSizePixels: 12,
                axisLabelFontFamily: 'Verdana, Arial',
                axisLabelPadding: 20,
            },
            legend: { noColumns: 2,show: true, container: '#legendLatencyVsRequest' },
            selection: {
                mode: 'xy'
            },
            grid: {
                hoverable: true // IMPORTANT! this is needed for tooltip to work
            },
            tooltip: true,
            tooltipOpts: {
                content: "%s : Median Latency time at %x req/s was %y ms"
            },
            colors: ["#9ACD32", "#FF6347"]
        };
    },
    createGraph: function () {
        var data = this.data;
        var dataset = prepareData(data.result.series, $("#choicesLatencyVsRequest"));
        var options = this.getOptions();
        prepareOptions(options, data);
        $.plot($("#flotLatenciesVsRequest"), dataset, options);
        // setup overview
        $.plot($("#overviewLatenciesVsRequest"), dataset, prepareOverviewOptions(options));
    }
};

// Latencies vs Request
function refreshLatenciesVsRequest() {
        var infos = latenciesVsRequestInfos;
        prepareSeries(infos.data);
        if(isGraph($("#flotLatenciesVsRequest"))){
            infos.createGraph();
        }else{
            var choiceContainer = $("#choicesLatencyVsRequest");
            createLegend(choiceContainer, infos);
            infos.createGraph();
            setGraphZoomable("#flotLatenciesVsRequest", "#overviewLatenciesVsRequest");
            $('#footerLatenciesVsRequest .legendColorBox > div').each(function(i){
                $(this).clone().prependTo(choiceContainer.find("li").eq(i));
            });
        }
};

var hitsPerSecondInfos = {
        data: {"result": {"minY": 83.33333333333333, "minX": 1.78883814E12, "maxY": 83.33333333333333, "series": [{"data": [[1.78883814E12, 83.33333333333333]], "isOverall": false, "label": "hitsPerSecond", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883814E12, "title": "Hits Per Second"}},
        getOptions: function() {
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of hits / sec",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: "#legendHitsPerSecond"
                },
                selection: {
                    mode : 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s at %x was %y.2 hits/sec"
                }
            };
        },
        createGraph: function createGraph() {
            var data = this.data;
            var dataset = prepareData(data.result.series, $("#choicesHitsPerSecond"));
            var options = this.getOptions();
            prepareOptions(options, data);
            $.plot($("#flotHitsPerSecond"), dataset, options);
            // setup overview
            $.plot($("#overviewHitsPerSecond"), dataset, prepareOverviewOptions(options));
        }
};

// Hits per second
function refreshHitsPerSecond(fixTimestamps) {
    var infos = hitsPerSecondInfos;
    prepareSeries(infos.data);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if (isGraph($("#flotHitsPerSecond"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesHitsPerSecond");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotHitsPerSecond", "#overviewHitsPerSecond");
        $('#footerHitsPerSecond .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
}

var codesPerSecondInfos = {
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883814E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78883814E12, 1.6666666666666667]], "isOverall": false, "label": "200", "isController": false}, {"data": [[1.78883814E12, 81.66666666666667]], "isOverall": false, "label": "400", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883814E12, "title": "Codes Per Second"}},
        getOptions: function(){
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of responses / sec",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: "#legendCodesPerSecond"
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "Number of Response Codes %s at %x was %y.2 responses / sec"
                }
            };
        },
    createGraph: function() {
        var data = this.data;
        var dataset = prepareData(data.result.series, $("#choicesCodesPerSecond"));
        var options = this.getOptions();
        prepareOptions(options, data);
        $.plot($("#flotCodesPerSecond"), dataset, options);
        // setup overview
        $.plot($("#overviewCodesPerSecond"), dataset, prepareOverviewOptions(options));
    }
};

// Codes per second
function refreshCodesPerSecond(fixTimestamps) {
    var infos = codesPerSecondInfos;
    prepareSeries(infos.data);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotCodesPerSecond"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesCodesPerSecond");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotCodesPerSecond", "#overviewCodesPerSecond");
        $('#footerCodesPerSecond .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var transactionsPerSecondInfos = {
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883814E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78883814E12, 81.66666666666667]], "isOverall": false, "label": "POST /api/seckill-failure", "isController": false}, {"data": [[1.78883814E12, 1.6666666666666667]], "isOverall": false, "label": "POST /api/seckill-success", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883814E12, "title": "Transactions Per Second"}},
        getOptions: function(){
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of transactions / sec",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: "#legendTransactionsPerSecond"
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s at %x was %y transactions / sec"
                }
            };
        },
    createGraph: function () {
        var data = this.data;
        var dataset = prepareData(data.result.series, $("#choicesTransactionsPerSecond"));
        var options = this.getOptions();
        prepareOptions(options, data);
        $.plot($("#flotTransactionsPerSecond"), dataset, options);
        // setup overview
        $.plot($("#overviewTransactionsPerSecond"), dataset, prepareOverviewOptions(options));
    }
};

// Transactions per second
function refreshTransactionsPerSecond(fixTimestamps) {
    var infos = transactionsPerSecondInfos;
    prepareSeries(infos.data);
    if(infos.data.result.series.length == 0) {
        setEmptyGraph("#bodyTransactionsPerSecond");
        return;
    }
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotTransactionsPerSecond"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesTransactionsPerSecond");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotTransactionsPerSecond", "#overviewTransactionsPerSecond");
        $('#footerTransactionsPerSecond .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

var totalTPSInfos = {
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883814E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78883814E12, 1.6666666666666667]], "isOverall": false, "label": "Transaction-success", "isController": false}, {"data": [[1.78883814E12, 81.66666666666667]], "isOverall": false, "label": "Transaction-failure", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883814E12, "title": "Total Transactions Per Second"}},
        getOptions: function(){
            return {
                series: {
                    lines: {
                        show: true
                    },
                    points: {
                        show: true
                    }
                },
                xaxis: {
                    mode: "time",
                    timeformat: getTimeFormat(this.data.result.granularity),
                    axisLabel: getElapsedTimeLabel(this.data.result.granularity),
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20,
                },
                yaxis: {
                    axisLabel: "Number of transactions / sec",
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',
                    axisLabelPadding: 20
                },
                legend: {
                    noColumns: 2,
                    show: true,
                    container: "#legendTotalTPS"
                },
                selection: {
                    mode: 'xy'
                },
                grid: {
                    hoverable: true // IMPORTANT! this is needed for tooltip to
                                    // work
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s at %x was %y transactions / sec"
                },
                colors: ["#9ACD32", "#FF6347"]
            };
        },
    createGraph: function () {
        var data = this.data;
        var dataset = prepareData(data.result.series, $("#choicesTotalTPS"));
        var options = this.getOptions();
        prepareOptions(options, data);
        $.plot($("#flotTotalTPS"), dataset, options);
        // setup overview
        $.plot($("#overviewTotalTPS"), dataset, prepareOverviewOptions(options));
    }
};

// Total Transactions per second
function refreshTotalTPS(fixTimestamps) {
    var infos = totalTPSInfos;
    // We want to ignore seriesFilter
    prepareSeries(infos.data, false, true);
    if(fixTimestamps) {
        fixTimeStamps(infos.data.result.series, 28800000);
    }
    if(isGraph($("#flotTotalTPS"))){
        infos.createGraph();
    }else{
        var choiceContainer = $("#choicesTotalTPS");
        createLegend(choiceContainer, infos);
        infos.createGraph();
        setGraphZoomable("#flotTotalTPS", "#overviewTotalTPS");
        $('#footerTotalTPS .legendColorBox > div').each(function(i){
            $(this).clone().prependTo(choiceContainer.find("li").eq(i));
        });
    }
};

// Collapse the graph matching the specified DOM element depending the collapsed
// status
function collapse(elem, collapsed){
    if(collapsed){
        $(elem).parent().find(".fa-chevron-up").removeClass("fa-chevron-up").addClass("fa-chevron-down");
    } else {
        $(elem).parent().find(".fa-chevron-down").removeClass("fa-chevron-down").addClass("fa-chevron-up");
        if (elem.id == "bodyBytesThroughputOverTime") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshBytesThroughputOverTime(true);
            }
            document.location.href="#bytesThroughputOverTime";
        } else if (elem.id == "bodyLatenciesOverTime") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshLatenciesOverTime(true);
            }
            document.location.href="#latenciesOverTime";
        } else if (elem.id == "bodyCustomGraph") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshCustomGraph(true);
            }
            document.location.href="#responseCustomGraph";
        } else if (elem.id == "bodyConnectTimeOverTime") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshConnectTimeOverTime(true);
            }
            document.location.href="#connectTimeOverTime";
        } else if (elem.id == "bodyResponseTimePercentilesOverTime") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshResponseTimePercentilesOverTime(true);
            }
            document.location.href="#responseTimePercentilesOverTime";
        } else if (elem.id == "bodyResponseTimeDistribution") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshResponseTimeDistribution();
            }
            document.location.href="#responseTimeDistribution" ;
        } else if (elem.id == "bodySyntheticResponseTimeDistribution") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshSyntheticResponseTimeDistribution();
            }
            document.location.href="#syntheticResponseTimeDistribution" ;
        } else if (elem.id == "bodyActiveThreadsOverTime") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshActiveThreadsOverTime(true);
            }
            document.location.href="#activeThreadsOverTime";
        } else if (elem.id == "bodyTimeVsThreads") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshTimeVsThreads();
            }
            document.location.href="#timeVsThreads" ;
        } else if (elem.id == "bodyCodesPerSecond") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshCodesPerSecond(true);
            }
            document.location.href="#codesPerSecond";
        } else if (elem.id == "bodyTransactionsPerSecond") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshTransactionsPerSecond(true);
            }
            document.location.href="#transactionsPerSecond";
        } else if (elem.id == "bodyTotalTPS") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshTotalTPS(true);
            }
            document.location.href="#totalTPS";
        } else if (elem.id == "bodyResponseTimeVsRequest") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshResponseTimeVsRequest();
            }
            document.location.href="#responseTimeVsRequest";
        } else if (elem.id == "bodyLatenciesVsRequest") {
            if (isGraph($(elem).find('.flot-chart-content')) == false) {
                refreshLatenciesVsRequest();
            }
            document.location.href="#latencyVsRequest";
        }
    }
}

/*
 * Activates or deactivates all series of the specified graph (represented by id parameter)
 * depending on checked argument.
 */
function toggleAll(id, checked){
    var placeholder = document.getElementById(id);

    var cases = $(placeholder).find(':checkbox');
    cases.prop('checked', checked);
    $(cases).parent().children().children().toggleClass("legend-disabled", !checked);

    var choiceContainer;
    if ( id == "choicesBytesThroughputOverTime"){
        choiceContainer = $("#choicesBytesThroughputOverTime");
        refreshBytesThroughputOverTime(false);
    } else if(id == "choicesResponseTimesOverTime"){
        choiceContainer = $("#choicesResponseTimesOverTime");
        refreshResponseTimeOverTime(false);
    }else if(id == "choicesResponseCustomGraph"){
        choiceContainer = $("#choicesResponseCustomGraph");
        refreshCustomGraph(false);
    } else if ( id == "choicesLatenciesOverTime"){
        choiceContainer = $("#choicesLatenciesOverTime");
        refreshLatenciesOverTime(false);
    } else if ( id == "choicesConnectTimeOverTime"){
        choiceContainer = $("#choicesConnectTimeOverTime");
        refreshConnectTimeOverTime(false);
    } else if ( id == "choicesResponseTimePercentilesOverTime"){
        choiceContainer = $("#choicesResponseTimePercentilesOverTime");
        refreshResponseTimePercentilesOverTime(false);
    } else if ( id == "choicesResponseTimePercentiles"){
        choiceContainer = $("#choicesResponseTimePercentiles");
        refreshResponseTimePercentiles();
    } else if(id == "choicesActiveThreadsOverTime"){
        choiceContainer = $("#choicesActiveThreadsOverTime");
        refreshActiveThreadsOverTime(false);
    } else if ( id == "choicesTimeVsThreads"){
        choiceContainer = $("#choicesTimeVsThreads");
        refreshTimeVsThreads();
    } else if ( id == "choicesSyntheticResponseTimeDistribution"){
        choiceContainer = $("#choicesSyntheticResponseTimeDistribution");
        refreshSyntheticResponseTimeDistribution();
    } else if ( id == "choicesResponseTimeDistribution"){
        choiceContainer = $("#choicesResponseTimeDistribution");
        refreshResponseTimeDistribution();
    } else if ( id == "choicesHitsPerSecond"){
        choiceContainer = $("#choicesHitsPerSecond");
        refreshHitsPerSecond(false);
    } else if(id == "choicesCodesPerSecond"){
        choiceContainer = $("#choicesCodesPerSecond");
        refreshCodesPerSecond(false);
    } else if ( id == "choicesTransactionsPerSecond"){
        choiceContainer = $("#choicesTransactionsPerSecond");
        refreshTransactionsPerSecond(false);
    } else if ( id == "choicesTotalTPS"){
        choiceContainer = $("#choicesTotalTPS");
        refreshTotalTPS(false);
    } else if ( id == "choicesResponseTimeVsRequest"){
        choiceContainer = $("#choicesResponseTimeVsRequest");
        refreshResponseTimeVsRequest();
    } else if ( id == "choicesLatencyVsRequest"){
        choiceContainer = $("#choicesLatencyVsRequest");
        refreshLatenciesVsRequest();
    }
    var color = checked ? "black" : "#818181";
    if(choiceContainer != null) {
        choiceContainer.find("label").each(function(){
            this.style.color = color;
        });
    }
}

