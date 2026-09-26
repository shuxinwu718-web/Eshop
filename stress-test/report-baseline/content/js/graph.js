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
        data: {"result": {"minY": 40.0, "minX": 0.0, "maxY": 3092.0, "series": [{"data": [[0.0, 40.0], [0.1, 48.0], [0.2, 53.0], [0.3, 54.0], [0.4, 59.0], [0.5, 61.0], [0.6, 63.0], [0.7, 66.0], [0.8, 68.0], [0.9, 71.0], [1.0, 73.0], [1.1, 75.0], [1.2, 76.0], [1.3, 77.0], [1.4, 81.0], [1.5, 83.0], [1.6, 85.0], [1.7, 85.0], [1.8, 88.0], [1.9, 90.0], [2.0, 92.0], [2.1, 93.0], [2.2, 94.0], [2.3, 96.0], [2.4, 99.0], [2.5, 101.0], [2.6, 101.0], [2.7, 105.0], [2.8, 107.0], [2.9, 109.0], [3.0, 111.0], [3.1, 112.0], [3.2, 113.0], [3.3, 114.0], [3.4, 115.0], [3.5, 117.0], [3.6, 118.0], [3.7, 120.0], [3.8, 123.0], [3.9, 124.0], [4.0, 125.0], [4.1, 127.0], [4.2, 128.0], [4.3, 130.0], [4.4, 131.0], [4.5, 132.0], [4.6, 133.0], [4.7, 134.0], [4.8, 135.0], [4.9, 135.0], [5.0, 136.0], [5.1, 137.0], [5.2, 138.0], [5.3, 138.0], [5.4, 139.0], [5.5, 140.0], [5.6, 141.0], [5.7, 142.0], [5.8, 143.0], [5.9, 144.0], [6.0, 144.0], [6.1, 145.0], [6.2, 146.0], [6.3, 147.0], [6.4, 147.0], [6.5, 148.0], [6.6, 149.0], [6.7, 150.0], [6.8, 150.0], [6.9, 151.0], [7.0, 151.0], [7.1, 152.0], [7.2, 152.0], [7.3, 153.0], [7.4, 154.0], [7.5, 155.0], [7.6, 155.0], [7.7, 156.0], [7.8, 157.0], [7.9, 158.0], [8.0, 158.0], [8.1, 159.0], [8.2, 160.0], [8.3, 161.0], [8.4, 161.0], [8.5, 162.0], [8.6, 162.0], [8.7, 163.0], [8.8, 164.0], [8.9, 165.0], [9.0, 166.0], [9.1, 167.0], [9.2, 167.0], [9.3, 168.0], [9.4, 168.0], [9.5, 169.0], [9.6, 169.0], [9.7, 169.0], [9.8, 170.0], [9.9, 170.0], [10.0, 171.0], [10.1, 171.0], [10.2, 172.0], [10.3, 173.0], [10.4, 173.0], [10.5, 173.0], [10.6, 174.0], [10.7, 175.0], [10.8, 175.0], [10.9, 176.0], [11.0, 176.0], [11.1, 176.0], [11.2, 177.0], [11.3, 177.0], [11.4, 177.0], [11.5, 178.0], [11.6, 178.0], [11.7, 179.0], [11.8, 179.0], [11.9, 180.0], [12.0, 180.0], [12.1, 181.0], [12.2, 181.0], [12.3, 182.0], [12.4, 182.0], [12.5, 183.0], [12.6, 183.0], [12.7, 183.0], [12.8, 184.0], [12.9, 184.0], [13.0, 185.0], [13.1, 185.0], [13.2, 185.0], [13.3, 186.0], [13.4, 186.0], [13.5, 187.0], [13.6, 187.0], [13.7, 187.0], [13.8, 188.0], [13.9, 189.0], [14.0, 189.0], [14.1, 189.0], [14.2, 190.0], [14.3, 190.0], [14.4, 191.0], [14.5, 192.0], [14.6, 192.0], [14.7, 193.0], [14.8, 193.0], [14.9, 193.0], [15.0, 194.0], [15.1, 194.0], [15.2, 195.0], [15.3, 195.0], [15.4, 195.0], [15.5, 196.0], [15.6, 196.0], [15.7, 197.0], [15.8, 197.0], [15.9, 198.0], [16.0, 198.0], [16.1, 199.0], [16.2, 199.0], [16.3, 199.0], [16.4, 200.0], [16.5, 200.0], [16.6, 201.0], [16.7, 202.0], [16.8, 202.0], [16.9, 202.0], [17.0, 203.0], [17.1, 203.0], [17.2, 203.0], [17.3, 203.0], [17.4, 204.0], [17.5, 204.0], [17.6, 204.0], [17.7, 205.0], [17.8, 205.0], [17.9, 206.0], [18.0, 206.0], [18.1, 206.0], [18.2, 207.0], [18.3, 207.0], [18.4, 207.0], [18.5, 208.0], [18.6, 208.0], [18.7, 208.0], [18.8, 209.0], [18.9, 209.0], [19.0, 210.0], [19.1, 210.0], [19.2, 210.0], [19.3, 211.0], [19.4, 211.0], [19.5, 211.0], [19.6, 212.0], [19.7, 212.0], [19.8, 212.0], [19.9, 213.0], [20.0, 214.0], [20.1, 214.0], [20.2, 214.0], [20.3, 215.0], [20.4, 215.0], [20.5, 215.0], [20.6, 216.0], [20.7, 216.0], [20.8, 216.0], [20.9, 216.0], [21.0, 217.0], [21.1, 217.0], [21.2, 217.0], [21.3, 218.0], [21.4, 218.0], [21.5, 218.0], [21.6, 218.0], [21.7, 219.0], [21.8, 219.0], [21.9, 219.0], [22.0, 219.0], [22.1, 220.0], [22.2, 220.0], [22.3, 221.0], [22.4, 222.0], [22.5, 222.0], [22.6, 222.0], [22.7, 222.0], [22.8, 223.0], [22.9, 223.0], [23.0, 224.0], [23.1, 224.0], [23.2, 224.0], [23.3, 225.0], [23.4, 225.0], [23.5, 225.0], [23.6, 225.0], [23.7, 226.0], [23.8, 226.0], [23.9, 226.0], [24.0, 227.0], [24.1, 227.0], [24.2, 227.0], [24.3, 228.0], [24.4, 228.0], [24.5, 228.0], [24.6, 228.0], [24.7, 229.0], [24.8, 229.0], [24.9, 229.0], [25.0, 229.0], [25.1, 230.0], [25.2, 230.0], [25.3, 230.0], [25.4, 231.0], [25.5, 231.0], [25.6, 232.0], [25.7, 232.0], [25.8, 232.0], [25.9, 232.0], [26.0, 233.0], [26.1, 233.0], [26.2, 233.0], [26.3, 233.0], [26.4, 234.0], [26.5, 234.0], [26.6, 234.0], [26.7, 235.0], [26.8, 235.0], [26.9, 235.0], [27.0, 235.0], [27.1, 235.0], [27.2, 236.0], [27.3, 236.0], [27.4, 236.0], [27.5, 237.0], [27.6, 237.0], [27.7, 237.0], [27.8, 237.0], [27.9, 238.0], [28.0, 238.0], [28.1, 238.0], [28.2, 239.0], [28.3, 239.0], [28.4, 239.0], [28.5, 240.0], [28.6, 240.0], [28.7, 240.0], [28.8, 240.0], [28.9, 241.0], [29.0, 241.0], [29.1, 241.0], [29.2, 242.0], [29.3, 242.0], [29.4, 242.0], [29.5, 243.0], [29.6, 243.0], [29.7, 243.0], [29.8, 243.0], [29.9, 244.0], [30.0, 244.0], [30.1, 244.0], [30.2, 244.0], [30.3, 245.0], [30.4, 245.0], [30.5, 246.0], [30.6, 246.0], [30.7, 246.0], [30.8, 246.0], [30.9, 247.0], [31.0, 247.0], [31.1, 248.0], [31.2, 248.0], [31.3, 248.0], [31.4, 249.0], [31.5, 249.0], [31.6, 249.0], [31.7, 249.0], [31.8, 250.0], [31.9, 250.0], [32.0, 250.0], [32.1, 250.0], [32.2, 251.0], [32.3, 251.0], [32.4, 252.0], [32.5, 252.0], [32.6, 252.0], [32.7, 252.0], [32.8, 253.0], [32.9, 253.0], [33.0, 253.0], [33.1, 253.0], [33.2, 254.0], [33.3, 254.0], [33.4, 254.0], [33.5, 255.0], [33.6, 255.0], [33.7, 255.0], [33.8, 256.0], [33.9, 256.0], [34.0, 256.0], [34.1, 256.0], [34.2, 257.0], [34.3, 257.0], [34.4, 257.0], [34.5, 258.0], [34.6, 258.0], [34.7, 258.0], [34.8, 259.0], [34.9, 259.0], [35.0, 259.0], [35.1, 260.0], [35.2, 260.0], [35.3, 261.0], [35.4, 261.0], [35.5, 261.0], [35.6, 261.0], [35.7, 261.0], [35.8, 262.0], [35.9, 262.0], [36.0, 263.0], [36.1, 263.0], [36.2, 263.0], [36.3, 264.0], [36.4, 264.0], [36.5, 264.0], [36.6, 265.0], [36.7, 265.0], [36.8, 265.0], [36.9, 265.0], [37.0, 265.0], [37.1, 266.0], [37.2, 266.0], [37.3, 266.0], [37.4, 267.0], [37.5, 267.0], [37.6, 267.0], [37.7, 268.0], [37.8, 268.0], [37.9, 268.0], [38.0, 269.0], [38.1, 269.0], [38.2, 269.0], [38.3, 269.0], [38.4, 269.0], [38.5, 270.0], [38.6, 270.0], [38.7, 270.0], [38.8, 270.0], [38.9, 270.0], [39.0, 271.0], [39.1, 271.0], [39.2, 271.0], [39.3, 271.0], [39.4, 271.0], [39.5, 272.0], [39.6, 272.0], [39.7, 272.0], [39.8, 272.0], [39.9, 273.0], [40.0, 273.0], [40.1, 273.0], [40.2, 273.0], [40.3, 273.0], [40.4, 274.0], [40.5, 274.0], [40.6, 274.0], [40.7, 274.0], [40.8, 275.0], [40.9, 275.0], [41.0, 275.0], [41.1, 275.0], [41.2, 275.0], [41.3, 276.0], [41.4, 276.0], [41.5, 276.0], [41.6, 276.0], [41.7, 277.0], [41.8, 277.0], [41.9, 277.0], [42.0, 278.0], [42.1, 278.0], [42.2, 278.0], [42.3, 279.0], [42.4, 279.0], [42.5, 279.0], [42.6, 280.0], [42.7, 280.0], [42.8, 280.0], [42.9, 281.0], [43.0, 281.0], [43.1, 281.0], [43.2, 281.0], [43.3, 282.0], [43.4, 282.0], [43.5, 282.0], [43.6, 282.0], [43.7, 283.0], [43.8, 283.0], [43.9, 283.0], [44.0, 283.0], [44.1, 284.0], [44.2, 284.0], [44.3, 285.0], [44.4, 285.0], [44.5, 285.0], [44.6, 285.0], [44.7, 286.0], [44.8, 286.0], [44.9, 287.0], [45.0, 287.0], [45.1, 287.0], [45.2, 287.0], [45.3, 288.0], [45.4, 288.0], [45.5, 289.0], [45.6, 289.0], [45.7, 289.0], [45.8, 289.0], [45.9, 290.0], [46.0, 290.0], [46.1, 290.0], [46.2, 290.0], [46.3, 291.0], [46.4, 291.0], [46.5, 292.0], [46.6, 292.0], [46.7, 292.0], [46.8, 292.0], [46.9, 292.0], [47.0, 293.0], [47.1, 293.0], [47.2, 294.0], [47.3, 294.0], [47.4, 294.0], [47.5, 295.0], [47.6, 295.0], [47.7, 295.0], [47.8, 296.0], [47.9, 296.0], [48.0, 296.0], [48.1, 297.0], [48.2, 297.0], [48.3, 297.0], [48.4, 297.0], [48.5, 297.0], [48.6, 298.0], [48.7, 298.0], [48.8, 298.0], [48.9, 298.0], [49.0, 298.0], [49.1, 299.0], [49.2, 299.0], [49.3, 299.0], [49.4, 299.0], [49.5, 300.0], [49.6, 300.0], [49.7, 300.0], [49.8, 300.0], [49.9, 301.0], [50.0, 301.0], [50.1, 301.0], [50.2, 302.0], [50.3, 302.0], [50.4, 302.0], [50.5, 302.0], [50.6, 303.0], [50.7, 303.0], [50.8, 303.0], [50.9, 304.0], [51.0, 304.0], [51.1, 304.0], [51.2, 305.0], [51.3, 305.0], [51.4, 305.0], [51.5, 305.0], [51.6, 305.0], [51.7, 306.0], [51.8, 306.0], [51.9, 307.0], [52.0, 307.0], [52.1, 307.0], [52.2, 307.0], [52.3, 307.0], [52.4, 308.0], [52.5, 308.0], [52.6, 308.0], [52.7, 309.0], [52.8, 309.0], [52.9, 309.0], [53.0, 309.0], [53.1, 309.0], [53.2, 310.0], [53.3, 311.0], [53.4, 311.0], [53.5, 311.0], [53.6, 311.0], [53.7, 312.0], [53.8, 312.0], [53.9, 312.0], [54.0, 313.0], [54.1, 313.0], [54.2, 314.0], [54.3, 314.0], [54.4, 315.0], [54.5, 315.0], [54.6, 315.0], [54.7, 315.0], [54.8, 316.0], [54.9, 316.0], [55.0, 316.0], [55.1, 317.0], [55.2, 317.0], [55.3, 318.0], [55.4, 318.0], [55.5, 318.0], [55.6, 318.0], [55.7, 319.0], [55.8, 319.0], [55.9, 319.0], [56.0, 320.0], [56.1, 320.0], [56.2, 320.0], [56.3, 321.0], [56.4, 321.0], [56.5, 321.0], [56.6, 321.0], [56.7, 322.0], [56.8, 322.0], [56.9, 322.0], [57.0, 323.0], [57.1, 323.0], [57.2, 323.0], [57.3, 324.0], [57.4, 324.0], [57.5, 324.0], [57.6, 324.0], [57.7, 325.0], [57.8, 325.0], [57.9, 325.0], [58.0, 325.0], [58.1, 325.0], [58.2, 326.0], [58.3, 326.0], [58.4, 326.0], [58.5, 327.0], [58.6, 327.0], [58.7, 328.0], [58.8, 328.0], [58.9, 328.0], [59.0, 328.0], [59.1, 329.0], [59.2, 329.0], [59.3, 330.0], [59.4, 330.0], [59.5, 330.0], [59.6, 330.0], [59.7, 331.0], [59.8, 332.0], [59.9, 332.0], [60.0, 332.0], [60.1, 332.0], [60.2, 333.0], [60.3, 333.0], [60.4, 333.0], [60.5, 334.0], [60.6, 334.0], [60.7, 334.0], [60.8, 335.0], [60.9, 335.0], [61.0, 335.0], [61.1, 336.0], [61.2, 336.0], [61.3, 336.0], [61.4, 336.0], [61.5, 337.0], [61.6, 337.0], [61.7, 338.0], [61.8, 338.0], [61.9, 339.0], [62.0, 339.0], [62.1, 339.0], [62.2, 339.0], [62.3, 340.0], [62.4, 340.0], [62.5, 340.0], [62.6, 340.0], [62.7, 341.0], [62.8, 341.0], [62.9, 341.0], [63.0, 342.0], [63.1, 342.0], [63.2, 342.0], [63.3, 343.0], [63.4, 343.0], [63.5, 343.0], [63.6, 344.0], [63.7, 344.0], [63.8, 344.0], [63.9, 345.0], [64.0, 345.0], [64.1, 346.0], [64.2, 346.0], [64.3, 346.0], [64.4, 347.0], [64.5, 347.0], [64.6, 347.0], [64.7, 348.0], [64.8, 348.0], [64.9, 349.0], [65.0, 349.0], [65.1, 349.0], [65.2, 350.0], [65.3, 350.0], [65.4, 350.0], [65.5, 351.0], [65.6, 351.0], [65.7, 352.0], [65.8, 352.0], [65.9, 352.0], [66.0, 353.0], [66.1, 353.0], [66.2, 353.0], [66.3, 354.0], [66.4, 354.0], [66.5, 354.0], [66.6, 354.0], [66.7, 355.0], [66.8, 355.0], [66.9, 356.0], [67.0, 356.0], [67.1, 356.0], [67.2, 357.0], [67.3, 357.0], [67.4, 357.0], [67.5, 358.0], [67.6, 358.0], [67.7, 358.0], [67.8, 359.0], [67.9, 359.0], [68.0, 359.0], [68.1, 360.0], [68.2, 360.0], [68.3, 360.0], [68.4, 361.0], [68.5, 361.0], [68.6, 361.0], [68.7, 362.0], [68.8, 362.0], [68.9, 362.0], [69.0, 362.0], [69.1, 362.0], [69.2, 363.0], [69.3, 363.0], [69.4, 363.0], [69.5, 364.0], [69.6, 364.0], [69.7, 364.0], [69.8, 364.0], [69.9, 365.0], [70.0, 366.0], [70.1, 366.0], [70.2, 367.0], [70.3, 367.0], [70.4, 367.0], [70.5, 368.0], [70.6, 368.0], [70.7, 368.0], [70.8, 369.0], [70.9, 369.0], [71.0, 370.0], [71.1, 370.0], [71.2, 371.0], [71.3, 371.0], [71.4, 371.0], [71.5, 372.0], [71.6, 372.0], [71.7, 372.0], [71.8, 373.0], [71.9, 373.0], [72.0, 374.0], [72.1, 375.0], [72.2, 375.0], [72.3, 375.0], [72.4, 376.0], [72.5, 376.0], [72.6, 377.0], [72.7, 377.0], [72.8, 378.0], [72.9, 378.0], [73.0, 378.0], [73.1, 378.0], [73.2, 379.0], [73.3, 379.0], [73.4, 380.0], [73.5, 380.0], [73.6, 381.0], [73.7, 381.0], [73.8, 382.0], [73.9, 382.0], [74.0, 382.0], [74.1, 383.0], [74.2, 383.0], [74.3, 383.0], [74.4, 384.0], [74.5, 384.0], [74.6, 385.0], [74.7, 385.0], [74.8, 385.0], [74.9, 386.0], [75.0, 386.0], [75.1, 387.0], [75.2, 388.0], [75.3, 388.0], [75.4, 388.0], [75.5, 389.0], [75.6, 389.0], [75.7, 389.0], [75.8, 390.0], [75.9, 390.0], [76.0, 390.0], [76.1, 391.0], [76.2, 391.0], [76.3, 392.0], [76.4, 392.0], [76.5, 393.0], [76.6, 394.0], [76.7, 394.0], [76.8, 394.0], [76.9, 395.0], [77.0, 395.0], [77.1, 396.0], [77.2, 396.0], [77.3, 397.0], [77.4, 397.0], [77.5, 398.0], [77.6, 398.0], [77.7, 398.0], [77.8, 399.0], [77.9, 399.0], [78.0, 400.0], [78.1, 400.0], [78.2, 401.0], [78.3, 401.0], [78.4, 402.0], [78.5, 403.0], [78.6, 403.0], [78.7, 404.0], [78.8, 405.0], [78.9, 405.0], [79.0, 406.0], [79.1, 406.0], [79.2, 406.0], [79.3, 407.0], [79.4, 407.0], [79.5, 408.0], [79.6, 408.0], [79.7, 408.0], [79.8, 409.0], [79.9, 409.0], [80.0, 409.0], [80.1, 410.0], [80.2, 410.0], [80.3, 410.0], [80.4, 411.0], [80.5, 411.0], [80.6, 412.0], [80.7, 412.0], [80.8, 413.0], [80.9, 414.0], [81.0, 414.0], [81.1, 415.0], [81.2, 416.0], [81.3, 417.0], [81.4, 418.0], [81.5, 418.0], [81.6, 419.0], [81.7, 420.0], [81.8, 421.0], [81.9, 421.0], [82.0, 422.0], [82.1, 422.0], [82.2, 423.0], [82.3, 424.0], [82.4, 424.0], [82.5, 424.0], [82.6, 425.0], [82.7, 425.0], [82.8, 426.0], [82.9, 426.0], [83.0, 427.0], [83.1, 428.0], [83.2, 428.0], [83.3, 428.0], [83.4, 429.0], [83.5, 430.0], [83.6, 431.0], [83.7, 431.0], [83.8, 432.0], [83.9, 433.0], [84.0, 433.0], [84.1, 434.0], [84.2, 434.0], [84.3, 435.0], [84.4, 435.0], [84.5, 436.0], [84.6, 436.0], [84.7, 437.0], [84.8, 437.0], [84.9, 438.0], [85.0, 439.0], [85.1, 439.0], [85.2, 440.0], [85.3, 441.0], [85.4, 441.0], [85.5, 442.0], [85.6, 442.0], [85.7, 443.0], [85.8, 443.0], [85.9, 444.0], [86.0, 445.0], [86.1, 446.0], [86.2, 446.0], [86.3, 447.0], [86.4, 448.0], [86.5, 448.0], [86.6, 449.0], [86.7, 449.0], [86.8, 450.0], [86.9, 451.0], [87.0, 452.0], [87.1, 452.0], [87.2, 454.0], [87.3, 455.0], [87.4, 455.0], [87.5, 456.0], [87.6, 456.0], [87.7, 456.0], [87.8, 457.0], [87.9, 458.0], [88.0, 459.0], [88.1, 460.0], [88.2, 460.0], [88.3, 461.0], [88.4, 462.0], [88.5, 463.0], [88.6, 465.0], [88.7, 465.0], [88.8, 465.0], [88.9, 466.0], [89.0, 467.0], [89.1, 468.0], [89.2, 469.0], [89.3, 470.0], [89.4, 472.0], [89.5, 473.0], [89.6, 475.0], [89.7, 475.0], [89.8, 476.0], [89.9, 478.0], [90.0, 479.0], [90.1, 480.0], [90.2, 482.0], [90.3, 483.0], [90.4, 485.0], [90.5, 487.0], [90.6, 488.0], [90.7, 491.0], [90.8, 492.0], [90.9, 494.0], [91.0, 496.0], [91.1, 497.0], [91.2, 499.0], [91.3, 501.0], [91.4, 502.0], [91.5, 504.0], [91.6, 506.0], [91.7, 509.0], [91.8, 511.0], [91.9, 512.0], [92.0, 513.0], [92.1, 514.0], [92.2, 517.0], [92.3, 519.0], [92.4, 519.0], [92.5, 521.0], [92.6, 525.0], [92.7, 526.0], [92.8, 528.0], [92.9, 531.0], [93.0, 532.0], [93.1, 533.0], [93.2, 536.0], [93.3, 538.0], [93.4, 540.0], [93.5, 543.0], [93.6, 545.0], [93.7, 548.0], [93.8, 550.0], [93.9, 553.0], [94.0, 555.0], [94.1, 558.0], [94.2, 563.0], [94.3, 566.0], [94.4, 570.0], [94.5, 576.0], [94.6, 580.0], [94.7, 581.0], [94.8, 590.0], [94.9, 597.0], [95.0, 600.0], [95.1, 604.0], [95.2, 606.0], [95.3, 612.0], [95.4, 615.0], [95.5, 629.0], [95.6, 640.0], [95.7, 646.0], [95.8, 657.0], [95.9, 670.0], [96.0, 676.0], [96.1, 687.0], [96.2, 697.0], [96.3, 714.0], [96.4, 721.0], [96.5, 753.0], [96.6, 767.0], [96.7, 782.0], [96.8, 812.0], [96.9, 837.0], [97.0, 898.0], [97.1, 906.0], [97.2, 945.0], [97.3, 996.0], [97.4, 1076.0], [97.5, 1153.0], [97.6, 1264.0], [97.7, 1381.0], [97.8, 1454.0], [97.9, 1569.0], [98.0, 1630.0], [98.1, 1743.0], [98.2, 1821.0], [98.3, 1942.0], [98.4, 2049.0], [98.5, 2149.0], [98.6, 2219.0], [98.7, 2256.0], [98.8, 2320.0], [98.9, 2382.0], [99.0, 2425.0], [99.1, 2506.0], [99.2, 2563.0], [99.3, 2603.0], [99.4, 2693.0], [99.5, 2732.0], [99.6, 2764.0], [99.7, 2810.0], [99.8, 2945.0], [99.9, 3025.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 100.0, "title": "Response Time Percentiles"}},
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
        data: {"result": {"minY": 3.0, "minX": 0.0, "maxY": 1652.0, "series": [{"data": [[0.0, 121.0], [600.0, 64.0], [700.0, 28.0], [800.0, 15.0], [900.0, 12.0], [1000.0, 6.0], [1100.0, 4.0], [1200.0, 7.0], [1300.0, 5.0], [1400.0, 3.0], [1500.0, 7.0], [100.0, 697.0], [1600.0, 5.0], [1700.0, 7.0], [1800.0, 3.0], [1900.0, 6.0], [2000.0, 4.0], [2100.0, 7.0], [2200.0, 8.0], [2300.0, 9.0], [2400.0, 8.0], [2500.0, 10.0], [2600.0, 6.0], [2700.0, 12.0], [2800.0, 5.0], [2900.0, 7.0], [3000.0, 5.0], [200.0, 1652.0], [300.0, 1429.0], [400.0, 665.0], [500.0, 183.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 100, "maxX": 3000.0, "title": "Response Time Distribution"}},
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
        data: {"result": {"minY": 100.0, "minX": 0.0, "ticks": [[0, "Requests having \nresponse time <= 500ms"], [1, "Requests having \nresponse time > 500ms and <= 1,500ms"], [2, "Requests having \nresponse time > 1,500ms"], [3, "Requests in error"]], "maxY": 4900.0, "series": [{"data": [[0.0, 100.0]], "color": "#9ACD32", "isOverall": false, "label": "Requests having \nresponse time <= 500ms", "isController": false}, {"data": [], "color": "yellow", "isOverall": false, "label": "Requests having \nresponse time > 500ms and <= 1,500ms", "isController": false}, {"data": [], "color": "orange", "isOverall": false, "label": "Requests having \nresponse time > 1,500ms", "isController": false}, {"data": [[3.0, 4900.0]], "color": "#FF6347", "isOverall": false, "label": "Requests in error", "isController": false}], "supportsControllersDiscrimination": false, "maxX": 3.0, "title": "Synthetic Response Times Distribution"}},
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
        data: {"result": {"minY": 35.25641025641027, "minX": 1.78883652E12, "maxY": 86.51345438634867, "series": [{"data": [[1.78883652E12, 35.25641025641027], [1.78883658E12, 86.51345438634867]], "isOverall": false, "label": "Seckill Rush", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883658E12, "title": "Active Threads Over Time"}},
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
        data: {"result": {"minY": 52.0, "minX": 1.0, "maxY": 455.55757286192056, "series": [{"data": [[2.0, 58.5], [3.0, 54.0], [4.0, 68.0], [5.0, 61.8], [7.0, 52.0], [8.0, 181.33333333333334], [9.0, 110.42857142857143], [10.0, 54.0], [11.0, 74.0], [12.0, 70.0], [13.0, 79.88888888888889], [14.0, 92.83333333333334], [15.0, 99.44444444444444], [16.0, 100.75], [17.0, 105.28571428571429], [18.0, 156.05555555555557], [19.0, 149.2857142857143], [20.0, 173.42857142857144], [21.0, 180.99999999999997], [22.0, 174.44444444444446], [23.0, 179.66666666666669], [24.0, 156.74999999999997], [25.0, 155.39130434782612], [26.0, 137.25], [27.0, 149.4], [28.0, 176.88888888888889], [29.0, 159.875], [30.0, 207.75], [31.0, 169.41666666666669], [32.0, 197.4], [33.0, 197.37500000000003], [34.0, 160.9310344827586], [35.0, 211.83333333333334], [36.0, 183.09523809523807], [37.0, 224.42857142857144], [38.0, 172.61538461538464], [39.0, 202.14814814814815], [40.0, 189.12499999999997], [41.0, 193.625], [42.0, 271.00000000000006], [43.0, 240.53333333333336], [44.0, 195.2380952380952], [45.0, 273.4615384615385], [46.0, 225.29411764705884], [47.0, 213.61111111111111], [48.0, 232.08333333333331], [49.0, 187.26086956521738], [50.0, 286.6], [51.0, 245.19354838709674], [52.0, 254.47674418604646], [53.0, 216.36363636363637], [54.0, 219.7368421052632], [55.0, 239.9047619047619], [56.0, 241.41509433962264], [57.0, 249.60869565217394], [58.0, 242.5806451612903], [59.0, 234.44444444444443], [61.0, 410.71052631578937], [60.0, 220.65384615384616], [62.0, 419.2058823529412], [63.0, 351.9375], [64.0, 285.0], [65.0, 363.5], [66.0, 356.45652173913044], [67.0, 292.875], [68.0, 298.7826086956522], [69.0, 304.65624999999994], [70.0, 219.0], [71.0, 331.989010989011], [72.0, 257.68421052631584], [73.0, 345.7307692307692], [74.0, 306.17241379310343], [75.0, 398.25], [76.0, 409.95833333333326], [77.0, 329.51282051282055], [78.0, 306.8695652173912], [79.0, 272.54166666666663], [80.0, 292.37837837837833], [81.0, 394.2727272727273], [82.0, 287.5757575757576], [83.0, 292.48275862068965], [85.0, 309.5874999999999], [86.0, 296.96153846153834], [87.0, 277.6666666666667], [84.0, 342.33333333333337], [88.0, 274.05769230769226], [89.0, 318.8571428571429], [90.0, 336.2486772486773], [91.0, 329.8951612903225], [92.0, 289.35714285714283], [93.0, 298.2040816326531], [94.0, 340.5], [95.0, 337.6981132075471], [96.0, 328.5135135135135], [97.0, 351.6444444444446], [98.0, 357.1599999999999], [99.0, 332.53846153846143], [100.0, 455.55757286192056], [1.0, 71.66666666666667]], "isOverall": false, "label": "POST /api/seckill", "isController": false}, {"data": [[82.11559999999992, 359.0555999999998]], "isOverall": false, "label": "POST /api/seckill-Aggregated", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 100.0, "title": "Time VS Threads"}},
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
        data : {"result": {"minY": 2826.116666666667, "minX": 1.78883652E12, "maxY": 39843.88333333333, "series": [{"data": [[1.78883652E12, 3721.116666666667], [1.78883658E12, 39843.88333333333]], "isOverall": false, "label": "Bytes received per second", "isController": false}, {"data": [[1.78883652E12, 2826.116666666667], [1.78883658E12, 30113.883333333335]], "isOverall": false, "label": "Bytes sent per second", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883658E12, "title": "Bytes Throughput Over Time"}},
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
        data: {"result": {"minY": 162.61538461538444, "minX": 1.78883652E12, "maxY": 377.4920148763945, "series": [{"data": [[1.78883652E12, 162.61538461538444], [1.78883658E12, 377.4920148763945]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883658E12, "title": "Response Time Over Time"}},
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
        data: {"result": {"minY": 144.47086247086253, "minX": 1.78883652E12, "maxY": 325.28571428571377, "series": [{"data": [[1.78883652E12, 144.47086247086253], [1.78883658E12, 325.28571428571377]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883658E12, "title": "Latencies Over Time"}},
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
        data: {"result": {"minY": 1.0717567271931698, "minX": 1.78883652E12, "maxY": 2.1048951048951072, "series": [{"data": [[1.78883652E12, 2.1048951048951072], [1.78883658E12, 1.0717567271931698]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883658E12, "title": "Connect Time Over Time"}},
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
        data: {"result": {"minY": 54.0, "minX": 1.78883652E12, "maxY": 254.0, "series": [{"data": [[1.78883652E12, 254.0]], "isOverall": false, "label": "Max", "isController": false}, {"data": [[1.78883652E12, 185.70000000000002]], "isOverall": false, "label": "90th percentile", "isController": false}, {"data": [[1.78883652E12, 253.91999999999996]], "isOverall": false, "label": "99th percentile", "isController": false}, {"data": [[1.78883652E12, 209.84999999999997]], "isOverall": false, "label": "95th percentile", "isController": false}, {"data": [[1.78883652E12, 54.0]], "isOverall": false, "label": "Min", "isController": false}, {"data": [[1.78883652E12, 127.0]], "isOverall": false, "label": "Median", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883652E12, "title": "Response Time Percentiles Over Time (successful requests only)"}},
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
    data: {"result": {"minY": 68.0, "minX": 16.0, "maxY": 2400.0, "series": [{"data": [[152.0, 154.0], [42.0, 85.0]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[152.0, 136.0], [165.0, 224.0], [175.0, 719.0], [190.0, 252.0], [47.0, 68.0], [199.0, 412.0], [196.0, 279.5], [212.0, 367.0], [235.0, 178.0], [246.0, 241.5], [16.0, 1582.5], [67.0, 2400.0], [257.0, 328.0], [262.0, 322.5], [272.0, 279.0], [287.0, 355.0], [72.0, 431.0], [292.0, 364.0], [298.0, 325.5], [329.0, 305.0], [335.0, 283.0], [333.0, 295.0], [321.0, 304.0]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 335.0, "title": "Response Time Vs Request"}},
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
    data: {"result": {"minY": 63.0, "minX": 16.0, "maxY": 2276.0, "series": [{"data": [[152.0, 147.5], [42.0, 80.5]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[152.0, 121.5], [165.0, 198.0], [175.0, 668.0], [190.0, 224.5], [47.0, 63.0], [199.0, 350.0], [196.0, 249.5], [212.0, 322.0], [235.0, 157.0], [246.0, 203.0], [16.0, 842.5], [67.0, 2276.0], [257.0, 276.0], [262.0, 273.5], [272.0, 238.0], [287.0, 298.0], [72.0, 340.5], [292.0, 317.5], [298.0, 283.0], [329.0, 268.0], [335.0, 252.0], [333.0, 248.0], [321.0, 255.0]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 335.0, "title": "Latencies Vs Request"}},
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
        data: {"result": {"minY": 8.066666666666666, "minX": 1.78883652E12, "maxY": 75.26666666666667, "series": [{"data": [[1.78883652E12, 8.066666666666666], [1.78883658E12, 75.26666666666667]], "isOverall": false, "label": "hitsPerSecond", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883658E12, "title": "Hits Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883652E12, "maxY": 76.18333333333334, "series": [{"data": [[1.78883652E12, 1.6666666666666667]], "isOverall": false, "label": "200", "isController": false}, {"data": [[1.78883652E12, 5.483333333333333], [1.78883658E12, 76.18333333333334]], "isOverall": false, "label": "400", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78883658E12, "title": "Codes Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883652E12, "maxY": 76.18333333333334, "series": [{"data": [[1.78883652E12, 5.483333333333333], [1.78883658E12, 76.18333333333334]], "isOverall": false, "label": "POST /api/seckill-failure", "isController": false}, {"data": [[1.78883652E12, 1.6666666666666667]], "isOverall": false, "label": "POST /api/seckill-success", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883658E12, "title": "Transactions Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78883652E12, "maxY": 76.18333333333334, "series": [{"data": [[1.78883652E12, 1.6666666666666667]], "isOverall": false, "label": "Transaction-success", "isController": false}, {"data": [[1.78883652E12, 5.483333333333333], [1.78883658E12, 76.18333333333334]], "isOverall": false, "label": "Transaction-failure", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78883658E12, "title": "Total Transactions Per Second"}},
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

