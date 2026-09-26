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
        data: {"result": {"minY": 17.0, "minX": 0.0, "maxY": 232.0, "series": [{"data": [[0.0, 17.0], [0.1, 20.0], [0.2, 23.0], [0.3, 23.0], [0.4, 24.0], [0.5, 25.0], [0.6, 26.0], [0.7, 28.0], [0.8, 28.0], [0.9, 29.0], [1.0, 29.0], [1.1, 30.0], [1.2, 31.0], [1.3, 31.0], [1.4, 31.0], [1.5, 32.0], [1.6, 32.0], [1.7, 32.0], [1.8, 33.0], [1.9, 34.0], [2.0, 34.0], [2.1, 34.0], [2.2, 34.0], [2.3, 34.0], [2.4, 35.0], [2.5, 35.0], [2.6, 35.0], [2.7, 35.0], [2.8, 36.0], [2.9, 36.0], [3.0, 37.0], [3.1, 37.0], [3.2, 37.0], [3.3, 37.0], [3.4, 38.0], [3.5, 38.0], [3.6, 38.0], [3.7, 38.0], [3.8, 39.0], [3.9, 39.0], [4.0, 39.0], [4.1, 40.0], [4.2, 40.0], [4.3, 40.0], [4.4, 40.0], [4.5, 40.0], [4.6, 41.0], [4.7, 41.0], [4.8, 41.0], [4.9, 41.0], [5.0, 42.0], [5.1, 42.0], [5.2, 42.0], [5.3, 42.0], [5.4, 42.0], [5.5, 43.0], [5.6, 43.0], [5.7, 43.0], [5.8, 43.0], [5.9, 44.0], [6.0, 44.0], [6.1, 44.0], [6.2, 44.0], [6.3, 44.0], [6.4, 45.0], [6.5, 45.0], [6.6, 45.0], [6.7, 45.0], [6.8, 45.0], [6.9, 46.0], [7.0, 46.0], [7.1, 46.0], [7.2, 46.0], [7.3, 46.0], [7.4, 46.0], [7.5, 47.0], [7.6, 47.0], [7.7, 47.0], [7.8, 47.0], [7.9, 47.0], [8.0, 48.0], [8.1, 48.0], [8.2, 48.0], [8.3, 48.0], [8.4, 48.0], [8.5, 48.0], [8.6, 48.0], [8.7, 48.0], [8.8, 49.0], [8.9, 49.0], [9.0, 49.0], [9.1, 49.0], [9.2, 49.0], [9.3, 49.0], [9.4, 49.0], [9.5, 49.0], [9.6, 49.0], [9.7, 50.0], [9.8, 50.0], [9.9, 50.0], [10.0, 50.0], [10.1, 50.0], [10.2, 50.0], [10.3, 51.0], [10.4, 51.0], [10.5, 51.0], [10.6, 51.0], [10.7, 51.0], [10.8, 51.0], [10.9, 51.0], [11.0, 52.0], [11.1, 52.0], [11.2, 52.0], [11.3, 52.0], [11.4, 52.0], [11.5, 52.0], [11.6, 52.0], [11.7, 52.0], [11.8, 53.0], [11.9, 53.0], [12.0, 53.0], [12.1, 53.0], [12.2, 53.0], [12.3, 53.0], [12.4, 53.0], [12.5, 53.0], [12.6, 54.0], [12.7, 54.0], [12.8, 54.0], [12.9, 54.0], [13.0, 54.0], [13.1, 54.0], [13.2, 54.0], [13.3, 55.0], [13.4, 55.0], [13.5, 55.0], [13.6, 55.0], [13.7, 55.0], [13.8, 56.0], [13.9, 56.0], [14.0, 56.0], [14.1, 56.0], [14.2, 56.0], [14.3, 56.0], [14.4, 56.0], [14.5, 56.0], [14.6, 57.0], [14.7, 57.0], [14.8, 57.0], [14.9, 57.0], [15.0, 57.0], [15.1, 57.0], [15.2, 57.0], [15.3, 57.0], [15.4, 57.0], [15.5, 58.0], [15.6, 58.0], [15.7, 58.0], [15.8, 58.0], [15.9, 58.0], [16.0, 58.0], [16.1, 58.0], [16.2, 58.0], [16.3, 59.0], [16.4, 59.0], [16.5, 59.0], [16.6, 59.0], [16.7, 59.0], [16.8, 59.0], [16.9, 59.0], [17.0, 59.0], [17.1, 60.0], [17.2, 60.0], [17.3, 60.0], [17.4, 60.0], [17.5, 60.0], [17.6, 60.0], [17.7, 60.0], [17.8, 60.0], [17.9, 60.0], [18.0, 60.0], [18.1, 61.0], [18.2, 61.0], [18.3, 61.0], [18.4, 61.0], [18.5, 61.0], [18.6, 61.0], [18.7, 61.0], [18.8, 61.0], [18.9, 61.0], [19.0, 61.0], [19.1, 61.0], [19.2, 62.0], [19.3, 62.0], [19.4, 62.0], [19.5, 62.0], [19.6, 62.0], [19.7, 62.0], [19.8, 62.0], [19.9, 62.0], [20.0, 62.0], [20.1, 62.0], [20.2, 62.0], [20.3, 63.0], [20.4, 63.0], [20.5, 63.0], [20.6, 63.0], [20.7, 63.0], [20.8, 63.0], [20.9, 63.0], [21.0, 63.0], [21.1, 63.0], [21.2, 63.0], [21.3, 64.0], [21.4, 64.0], [21.5, 64.0], [21.6, 64.0], [21.7, 64.0], [21.8, 64.0], [21.9, 64.0], [22.0, 64.0], [22.1, 64.0], [22.2, 64.0], [22.3, 65.0], [22.4, 65.0], [22.5, 65.0], [22.6, 65.0], [22.7, 65.0], [22.8, 65.0], [22.9, 65.0], [23.0, 65.0], [23.1, 65.0], [23.2, 65.0], [23.3, 66.0], [23.4, 66.0], [23.5, 66.0], [23.6, 66.0], [23.7, 66.0], [23.8, 66.0], [23.9, 66.0], [24.0, 66.0], [24.1, 67.0], [24.2, 67.0], [24.3, 67.0], [24.4, 67.0], [24.5, 67.0], [24.6, 67.0], [24.7, 67.0], [24.8, 67.0], [24.9, 67.0], [25.0, 67.0], [25.1, 67.0], [25.2, 68.0], [25.3, 68.0], [25.4, 68.0], [25.5, 68.0], [25.6, 68.0], [25.7, 68.0], [25.8, 68.0], [25.9, 68.0], [26.0, 68.0], [26.1, 68.0], [26.2, 68.0], [26.3, 68.0], [26.4, 69.0], [26.5, 69.0], [26.6, 69.0], [26.7, 69.0], [26.8, 69.0], [26.9, 69.0], [27.0, 69.0], [27.1, 69.0], [27.2, 69.0], [27.3, 69.0], [27.4, 69.0], [27.5, 70.0], [27.6, 70.0], [27.7, 70.0], [27.8, 70.0], [27.9, 70.0], [28.0, 70.0], [28.1, 70.0], [28.2, 70.0], [28.3, 70.0], [28.4, 70.0], [28.5, 70.0], [28.6, 71.0], [28.7, 71.0], [28.8, 71.0], [28.9, 71.0], [29.0, 71.0], [29.1, 71.0], [29.2, 71.0], [29.3, 71.0], [29.4, 72.0], [29.5, 72.0], [29.6, 72.0], [29.7, 72.0], [29.8, 72.0], [29.9, 72.0], [30.0, 72.0], [30.1, 72.0], [30.2, 72.0], [30.3, 72.0], [30.4, 72.0], [30.5, 73.0], [30.6, 73.0], [30.7, 73.0], [30.8, 73.0], [30.9, 73.0], [31.0, 73.0], [31.1, 73.0], [31.2, 73.0], [31.3, 73.0], [31.4, 73.0], [31.5, 73.0], [31.6, 73.0], [31.7, 73.0], [31.8, 74.0], [31.9, 74.0], [32.0, 74.0], [32.1, 74.0], [32.2, 74.0], [32.3, 74.0], [32.4, 74.0], [32.5, 74.0], [32.6, 74.0], [32.7, 74.0], [32.8, 74.0], [32.9, 74.0], [33.0, 75.0], [33.1, 75.0], [33.2, 75.0], [33.3, 75.0], [33.4, 75.0], [33.5, 75.0], [33.6, 75.0], [33.7, 75.0], [33.8, 75.0], [33.9, 75.0], [34.0, 75.0], [34.1, 75.0], [34.2, 75.0], [34.3, 75.0], [34.4, 76.0], [34.5, 76.0], [34.6, 76.0], [34.7, 76.0], [34.8, 76.0], [34.9, 76.0], [35.0, 76.0], [35.1, 76.0], [35.2, 76.0], [35.3, 76.0], [35.4, 76.0], [35.5, 77.0], [35.6, 77.0], [35.7, 77.0], [35.8, 77.0], [35.9, 77.0], [36.0, 77.0], [36.1, 77.0], [36.2, 77.0], [36.3, 77.0], [36.4, 77.0], [36.5, 77.0], [36.6, 77.0], [36.7, 78.0], [36.8, 78.0], [36.9, 78.0], [37.0, 78.0], [37.1, 78.0], [37.2, 78.0], [37.3, 78.0], [37.4, 78.0], [37.5, 78.0], [37.6, 79.0], [37.7, 79.0], [37.8, 79.0], [37.9, 79.0], [38.0, 79.0], [38.1, 79.0], [38.2, 79.0], [38.3, 79.0], [38.4, 79.0], [38.5, 79.0], [38.6, 79.0], [38.7, 79.0], [38.8, 80.0], [38.9, 80.0], [39.0, 80.0], [39.1, 80.0], [39.2, 80.0], [39.3, 80.0], [39.4, 80.0], [39.5, 80.0], [39.6, 80.0], [39.7, 80.0], [39.8, 80.0], [39.9, 81.0], [40.0, 81.0], [40.1, 81.0], [40.2, 81.0], [40.3, 81.0], [40.4, 81.0], [40.5, 81.0], [40.6, 81.0], [40.7, 81.0], [40.8, 82.0], [40.9, 82.0], [41.0, 82.0], [41.1, 82.0], [41.2, 82.0], [41.3, 82.0], [41.4, 82.0], [41.5, 82.0], [41.6, 82.0], [41.7, 82.0], [41.8, 82.0], [41.9, 82.0], [42.0, 82.0], [42.1, 82.0], [42.2, 83.0], [42.3, 83.0], [42.4, 83.0], [42.5, 83.0], [42.6, 83.0], [42.7, 83.0], [42.8, 83.0], [42.9, 83.0], [43.0, 83.0], [43.1, 83.0], [43.2, 83.0], [43.3, 83.0], [43.4, 84.0], [43.5, 84.0], [43.6, 84.0], [43.7, 84.0], [43.8, 84.0], [43.9, 84.0], [44.0, 84.0], [44.1, 84.0], [44.2, 84.0], [44.3, 84.0], [44.4, 84.0], [44.5, 84.0], [44.6, 85.0], [44.7, 85.0], [44.8, 85.0], [44.9, 85.0], [45.0, 85.0], [45.1, 85.0], [45.2, 85.0], [45.3, 85.0], [45.4, 85.0], [45.5, 85.0], [45.6, 85.0], [45.7, 85.0], [45.8, 85.0], [45.9, 85.0], [46.0, 86.0], [46.1, 86.0], [46.2, 86.0], [46.3, 86.0], [46.4, 86.0], [46.5, 86.0], [46.6, 86.0], [46.7, 86.0], [46.8, 86.0], [46.9, 86.0], [47.0, 86.0], [47.1, 86.0], [47.2, 86.0], [47.3, 87.0], [47.4, 87.0], [47.5, 87.0], [47.6, 87.0], [47.7, 87.0], [47.8, 87.0], [47.9, 87.0], [48.0, 87.0], [48.1, 87.0], [48.2, 87.0], [48.3, 87.0], [48.4, 88.0], [48.5, 88.0], [48.6, 88.0], [48.7, 88.0], [48.8, 88.0], [48.9, 88.0], [49.0, 88.0], [49.1, 88.0], [49.2, 88.0], [49.3, 88.0], [49.4, 88.0], [49.5, 88.0], [49.6, 88.0], [49.7, 88.0], [49.8, 88.0], [49.9, 88.0], [50.0, 89.0], [50.1, 89.0], [50.2, 89.0], [50.3, 89.0], [50.4, 89.0], [50.5, 89.0], [50.6, 89.0], [50.7, 89.0], [50.8, 89.0], [50.9, 89.0], [51.0, 89.0], [51.1, 89.0], [51.2, 89.0], [51.3, 90.0], [51.4, 90.0], [51.5, 90.0], [51.6, 90.0], [51.7, 90.0], [51.8, 90.0], [51.9, 90.0], [52.0, 90.0], [52.1, 90.0], [52.2, 90.0], [52.3, 91.0], [52.4, 91.0], [52.5, 91.0], [52.6, 91.0], [52.7, 91.0], [52.8, 91.0], [52.9, 91.0], [53.0, 91.0], [53.1, 91.0], [53.2, 91.0], [53.3, 91.0], [53.4, 91.0], [53.5, 91.0], [53.6, 92.0], [53.7, 92.0], [53.8, 92.0], [53.9, 92.0], [54.0, 92.0], [54.1, 92.0], [54.2, 92.0], [54.3, 92.0], [54.4, 92.0], [54.5, 92.0], [54.6, 92.0], [54.7, 92.0], [54.8, 93.0], [54.9, 93.0], [55.0, 93.0], [55.1, 93.0], [55.2, 93.0], [55.3, 93.0], [55.4, 93.0], [55.5, 93.0], [55.6, 93.0], [55.7, 93.0], [55.8, 93.0], [55.9, 94.0], [56.0, 94.0], [56.1, 94.0], [56.2, 94.0], [56.3, 94.0], [56.4, 94.0], [56.5, 94.0], [56.6, 94.0], [56.7, 94.0], [56.8, 94.0], [56.9, 94.0], [57.0, 94.0], [57.1, 94.0], [57.2, 94.0], [57.3, 94.0], [57.4, 94.0], [57.5, 94.0], [57.6, 95.0], [57.7, 95.0], [57.8, 95.0], [57.9, 95.0], [58.0, 95.0], [58.1, 95.0], [58.2, 95.0], [58.3, 95.0], [58.4, 95.0], [58.5, 95.0], [58.6, 95.0], [58.7, 96.0], [58.8, 96.0], [58.9, 96.0], [59.0, 96.0], [59.1, 96.0], [59.2, 96.0], [59.3, 96.0], [59.4, 96.0], [59.5, 96.0], [59.6, 96.0], [59.7, 96.0], [59.8, 97.0], [59.9, 97.0], [60.0, 97.0], [60.1, 97.0], [60.2, 97.0], [60.3, 97.0], [60.4, 97.0], [60.5, 97.0], [60.6, 97.0], [60.7, 97.0], [60.8, 97.0], [60.9, 97.0], [61.0, 97.0], [61.1, 97.0], [61.2, 98.0], [61.3, 98.0], [61.4, 98.0], [61.5, 98.0], [61.6, 98.0], [61.7, 98.0], [61.8, 98.0], [61.9, 98.0], [62.0, 98.0], [62.1, 98.0], [62.2, 98.0], [62.3, 98.0], [62.4, 99.0], [62.5, 99.0], [62.6, 99.0], [62.7, 99.0], [62.8, 99.0], [62.9, 99.0], [63.0, 99.0], [63.1, 99.0], [63.2, 99.0], [63.3, 99.0], [63.4, 99.0], [63.5, 99.0], [63.6, 99.0], [63.7, 100.0], [63.8, 100.0], [63.9, 100.0], [64.0, 100.0], [64.1, 100.0], [64.2, 100.0], [64.3, 100.0], [64.4, 100.0], [64.5, 100.0], [64.6, 100.0], [64.7, 100.0], [64.8, 100.0], [64.9, 100.0], [65.0, 101.0], [65.1, 101.0], [65.2, 101.0], [65.3, 101.0], [65.4, 101.0], [65.5, 101.0], [65.6, 101.0], [65.7, 101.0], [65.8, 101.0], [65.9, 101.0], [66.0, 101.0], [66.1, 101.0], [66.2, 102.0], [66.3, 102.0], [66.4, 102.0], [66.5, 102.0], [66.6, 102.0], [66.7, 102.0], [66.8, 102.0], [66.9, 102.0], [67.0, 102.0], [67.1, 102.0], [67.2, 103.0], [67.3, 103.0], [67.4, 103.0], [67.5, 103.0], [67.6, 103.0], [67.7, 103.0], [67.8, 103.0], [67.9, 103.0], [68.0, 103.0], [68.1, 103.0], [68.2, 104.0], [68.3, 104.0], [68.4, 104.0], [68.5, 104.0], [68.6, 104.0], [68.7, 104.0], [68.8, 104.0], [68.9, 104.0], [69.0, 104.0], [69.1, 104.0], [69.2, 105.0], [69.3, 105.0], [69.4, 105.0], [69.5, 105.0], [69.6, 105.0], [69.7, 105.0], [69.8, 105.0], [69.9, 105.0], [70.0, 105.0], [70.1, 105.0], [70.2, 105.0], [70.3, 105.0], [70.4, 106.0], [70.5, 106.0], [70.6, 106.0], [70.7, 106.0], [70.8, 106.0], [70.9, 106.0], [71.0, 106.0], [71.1, 106.0], [71.2, 106.0], [71.3, 106.0], [71.4, 107.0], [71.5, 107.0], [71.6, 107.0], [71.7, 107.0], [71.8, 107.0], [71.9, 107.0], [72.0, 107.0], [72.1, 107.0], [72.2, 107.0], [72.3, 107.0], [72.4, 107.0], [72.5, 107.0], [72.6, 108.0], [72.7, 108.0], [72.8, 108.0], [72.9, 108.0], [73.0, 108.0], [73.1, 108.0], [73.2, 108.0], [73.3, 108.0], [73.4, 108.0], [73.5, 108.0], [73.6, 108.0], [73.7, 108.0], [73.8, 109.0], [73.9, 109.0], [74.0, 109.0], [74.1, 109.0], [74.2, 109.0], [74.3, 109.0], [74.4, 109.0], [74.5, 109.0], [74.6, 109.0], [74.7, 109.0], [74.8, 109.0], [74.9, 109.0], [75.0, 110.0], [75.1, 110.0], [75.2, 110.0], [75.3, 110.0], [75.4, 110.0], [75.5, 110.0], [75.6, 110.0], [75.7, 110.0], [75.8, 110.0], [75.9, 110.0], [76.0, 111.0], [76.1, 111.0], [76.2, 111.0], [76.3, 111.0], [76.4, 111.0], [76.5, 111.0], [76.6, 111.0], [76.7, 111.0], [76.8, 111.0], [76.9, 112.0], [77.0, 112.0], [77.1, 112.0], [77.2, 112.0], [77.3, 112.0], [77.4, 112.0], [77.5, 112.0], [77.6, 112.0], [77.7, 112.0], [77.8, 112.0], [77.9, 113.0], [78.0, 113.0], [78.1, 113.0], [78.2, 113.0], [78.3, 113.0], [78.4, 113.0], [78.5, 113.0], [78.6, 113.0], [78.7, 113.0], [78.8, 114.0], [78.9, 114.0], [79.0, 114.0], [79.1, 114.0], [79.2, 114.0], [79.3, 114.0], [79.4, 114.0], [79.5, 114.0], [79.6, 115.0], [79.7, 115.0], [79.8, 115.0], [79.9, 115.0], [80.0, 115.0], [80.1, 115.0], [80.2, 116.0], [80.3, 116.0], [80.4, 116.0], [80.5, 116.0], [80.6, 116.0], [80.7, 116.0], [80.8, 116.0], [80.9, 116.0], [81.0, 116.0], [81.1, 117.0], [81.2, 117.0], [81.3, 117.0], [81.4, 117.0], [81.5, 117.0], [81.6, 117.0], [81.7, 118.0], [81.8, 118.0], [81.9, 118.0], [82.0, 118.0], [82.1, 118.0], [82.2, 118.0], [82.3, 118.0], [82.4, 119.0], [82.5, 119.0], [82.6, 119.0], [82.7, 119.0], [82.8, 119.0], [82.9, 120.0], [83.0, 120.0], [83.1, 120.0], [83.2, 120.0], [83.3, 120.0], [83.4, 120.0], [83.5, 120.0], [83.6, 121.0], [83.7, 121.0], [83.8, 121.0], [83.9, 121.0], [84.0, 121.0], [84.1, 121.0], [84.2, 122.0], [84.3, 122.0], [84.4, 122.0], [84.5, 122.0], [84.6, 122.0], [84.7, 122.0], [84.8, 123.0], [84.9, 123.0], [85.0, 123.0], [85.1, 123.0], [85.2, 123.0], [85.3, 124.0], [85.4, 124.0], [85.5, 124.0], [85.6, 124.0], [85.7, 125.0], [85.8, 125.0], [85.9, 125.0], [86.0, 125.0], [86.1, 125.0], [86.2, 126.0], [86.3, 126.0], [86.4, 126.0], [86.5, 126.0], [86.6, 126.0], [86.7, 126.0], [86.8, 126.0], [86.9, 126.0], [87.0, 127.0], [87.1, 127.0], [87.2, 127.0], [87.3, 127.0], [87.4, 127.0], [87.5, 127.0], [87.6, 128.0], [87.7, 128.0], [87.8, 128.0], [87.9, 128.0], [88.0, 128.0], [88.1, 128.0], [88.2, 128.0], [88.3, 129.0], [88.4, 129.0], [88.5, 129.0], [88.6, 129.0], [88.7, 130.0], [88.8, 130.0], [88.9, 130.0], [89.0, 131.0], [89.1, 131.0], [89.2, 131.0], [89.3, 131.0], [89.4, 131.0], [89.5, 131.0], [89.6, 131.0], [89.7, 132.0], [89.8, 132.0], [89.9, 132.0], [90.0, 133.0], [90.1, 133.0], [90.2, 133.0], [90.3, 133.0], [90.4, 133.0], [90.5, 134.0], [90.6, 134.0], [90.7, 134.0], [90.8, 134.0], [90.9, 134.0], [91.0, 135.0], [91.1, 135.0], [91.2, 135.0], [91.3, 136.0], [91.4, 136.0], [91.5, 136.0], [91.6, 136.0], [91.7, 137.0], [91.8, 137.0], [91.9, 137.0], [92.0, 137.0], [92.1, 137.0], [92.2, 138.0], [92.3, 138.0], [92.4, 139.0], [92.5, 139.0], [92.6, 139.0], [92.7, 139.0], [92.8, 140.0], [92.9, 140.0], [93.0, 140.0], [93.1, 141.0], [93.2, 141.0], [93.3, 141.0], [93.4, 142.0], [93.5, 142.0], [93.6, 142.0], [93.7, 142.0], [93.8, 143.0], [93.9, 143.0], [94.0, 143.0], [94.1, 143.0], [94.2, 144.0], [94.3, 144.0], [94.4, 145.0], [94.5, 145.0], [94.6, 145.0], [94.7, 145.0], [94.8, 146.0], [94.9, 146.0], [95.0, 147.0], [95.1, 147.0], [95.2, 148.0], [95.3, 148.0], [95.4, 148.0], [95.5, 148.0], [95.6, 148.0], [95.7, 149.0], [95.8, 150.0], [95.9, 150.0], [96.0, 151.0], [96.1, 151.0], [96.2, 152.0], [96.3, 152.0], [96.4, 153.0], [96.5, 153.0], [96.6, 153.0], [96.7, 154.0], [96.8, 154.0], [96.9, 155.0], [97.0, 155.0], [97.1, 156.0], [97.2, 156.0], [97.3, 157.0], [97.4, 158.0], [97.5, 160.0], [97.6, 160.0], [97.7, 161.0], [97.8, 162.0], [97.9, 162.0], [98.0, 163.0], [98.1, 163.0], [98.2, 164.0], [98.3, 164.0], [98.4, 165.0], [98.5, 166.0], [98.6, 167.0], [98.7, 168.0], [98.8, 170.0], [98.9, 173.0], [99.0, 174.0], [99.1, 174.0], [99.2, 176.0], [99.3, 177.0], [99.4, 180.0], [99.5, 184.0], [99.6, 187.0], [99.7, 192.0], [99.8, 195.0], [99.9, 209.0], [100.0, 232.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 100.0, "title": "Response Time Percentiles"}},
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
        data: {"result": {"minY": 7.0, "minX": 0.0, "maxY": 3181.0, "series": [{"data": [[0.0, 3181.0], [100.0, 1812.0], [200.0, 7.0]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 100, "maxX": 200.0, "title": "Response Time Distribution"}},
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
        data: {"result": {"minY": 36.68820000000008, "minX": 1.78884108E12, "maxY": 36.68820000000008, "series": [{"data": [[1.78884108E12, 36.68820000000008]], "isOverall": false, "label": "Seckill Rush", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78884108E12, "title": "Active Threads Over Time"}},
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
        data: {"result": {"minY": 29.5, "minX": 1.0, "maxY": 126.08695652173913, "series": [{"data": [[2.0, 49.0], [3.0, 60.22222222222222], [4.0, 29.5], [5.0, 37.42857142857142], [6.0, 33.53571428571428], [7.0, 47.55555555555555], [8.0, 41.59999999999999], [9.0, 50.56521739130434], [10.0, 47.173913043478265], [11.0, 43.34], [12.0, 47.02272727272728], [13.0, 56.93939393939393], [14.0, 53.47058823529413], [15.0, 49.85714285714286], [16.0, 52.1896551724138], [17.0, 59.269230769230774], [18.0, 59.26923076923076], [19.0, 59.44736842105262], [20.0, 63.06976744186046], [21.0, 76.12307692307691], [22.0, 108.34615384615383], [23.0, 83.91489361702126], [24.0, 102.10526315789473], [25.0, 73.0408163265306], [26.0, 88.01612903225808], [27.0, 67.49999999999997], [28.0, 69.88965517241382], [29.0, 78.20529801324503], [30.0, 79.03571428571426], [31.0, 89.90163934426228], [32.0, 85.30158730158729], [33.0, 81.83870967741937], [34.0, 84.03144654088052], [35.0, 87.76744186046508], [36.0, 86.1393442622951], [37.0, 97.54545454545456], [38.0, 86.66666666666667], [39.0, 97.56818181818181], [40.0, 96.1069518716578], [41.0, 105.27544910179645], [42.0, 98.50490196078428], [43.0, 90.48805460750852], [44.0, 88.37662337662333], [45.0, 96.44094488188975], [46.0, 100.86046511627907], [47.0, 115.05976095617527], [48.0, 109.82595870206497], [49.0, 99.04587155963303], [50.0, 108.97999999999995], [51.0, 112.7389162561576], [52.0, 108.85217391304349], [53.0, 114.60317460317465], [54.0, 126.08695652173913], [1.0, 51.5]], "isOverall": false, "label": "POST /api/seckill", "isController": false}, {"data": [[36.68799999999994, 90.25299999999986]], "isOverall": false, "label": "POST /api/seckill-Aggregated", "isController": false}], "supportsControllersDiscrimination": true, "maxX": 54.0, "title": "Time VS Threads"}},
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
        data : {"result": {"minY": 32940.0, "minX": 1.78884108E12, "maxY": 43565.0, "series": [{"data": [[1.78884108E12, 43565.0]], "isOverall": false, "label": "Bytes received per second", "isController": false}, {"data": [[1.78884108E12, 32940.0]], "isOverall": false, "label": "Bytes sent per second", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78884108E12, "title": "Bytes Throughput Over Time"}},
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
        data: {"result": {"minY": 90.25299999999986, "minX": 1.78884108E12, "maxY": 90.25299999999986, "series": [{"data": [[1.78884108E12, 90.25299999999986]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78884108E12, "title": "Response Time Over Time"}},
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
        data: {"result": {"minY": 88.46659999999981, "minX": 1.78884108E12, "maxY": 88.46659999999981, "series": [{"data": [[1.78884108E12, 88.46659999999981]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78884108E12, "title": "Latencies Over Time"}},
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
        data: {"result": {"minY": 1.3388000000000013, "minX": 1.78884108E12, "maxY": 1.3388000000000013, "series": [{"data": [[1.78884108E12, 1.3388000000000013]], "isOverall": false, "label": "POST /api/seckill", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78884108E12, "title": "Connect Time Over Time"}},
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
        data: {"result": {"minY": 24.0, "minX": 1.78884108E12, "maxY": 139.0, "series": [{"data": [[1.78884108E12, 139.0]], "isOverall": false, "label": "Max", "isController": false}, {"data": [[1.78884108E12, 61.70000000000002]], "isOverall": false, "label": "90th percentile", "isController": false}, {"data": [[1.78884108E12, 139.0]], "isOverall": false, "label": "99th percentile", "isController": false}, {"data": [[1.78884108E12, 79.69999999999993]], "isOverall": false, "label": "95th percentile", "isController": false}, {"data": [[1.78884108E12, 24.0]], "isOverall": false, "label": "Min", "isController": false}, {"data": [[1.78884108E12, 47.0]], "isOverall": false, "label": "Median", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78884108E12, "title": "Response Time Percentiles Over Time (successful requests only)"}},
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
    data: {"result": {"minY": 31.0, "minX": 27.0, "maxY": 107.5, "series": [{"data": [[27.0, 35.0], [230.0, 48.0]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[50.0, 31.0], [230.0, 43.0], [224.0, 73.0], [335.0, 61.0], [330.0, 82.0], [369.0, 85.0], [387.0, 67.0], [398.0, 90.5], [402.0, 98.0], [407.0, 97.0], [434.0, 107.5], [463.0, 105.0], [460.0, 90.0], [484.0, 106.0]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 484.0, "title": "Response Time Vs Request"}},
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
    data: {"result": {"minY": 29.0, "minX": 27.0, "maxY": 106.0, "series": [{"data": [[27.0, 35.0], [230.0, 48.0]], "isOverall": false, "label": "Successes", "isController": false}, {"data": [[50.0, 29.0], [230.0, 42.0], [224.0, 71.5], [335.0, 60.0], [330.0, 81.0], [369.0, 82.0], [387.0, 65.0], [398.0, 89.5], [402.0, 96.0], [407.0, 95.0], [434.0, 106.0], [463.0, 103.0], [460.0, 88.0], [484.0, 104.0]], "isOverall": false, "label": "Failures", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 1000, "maxX": 484.0, "title": "Latencies Vs Request"}},
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
        data: {"result": {"minY": 83.33333333333333, "minX": 1.78884108E12, "maxY": 83.33333333333333, "series": [{"data": [[1.78884108E12, 83.33333333333333]], "isOverall": false, "label": "hitsPerSecond", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78884108E12, "title": "Hits Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78884108E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78884108E12, 1.6666666666666667]], "isOverall": false, "label": "200", "isController": false}, {"data": [[1.78884108E12, 81.66666666666667]], "isOverall": false, "label": "400", "isController": false}], "supportsControllersDiscrimination": false, "granularity": 60000, "maxX": 1.78884108E12, "title": "Codes Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78884108E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78884108E12, 81.66666666666667]], "isOverall": false, "label": "POST /api/seckill-failure", "isController": false}, {"data": [[1.78884108E12, 1.6666666666666667]], "isOverall": false, "label": "POST /api/seckill-success", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78884108E12, "title": "Transactions Per Second"}},
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
        data: {"result": {"minY": 1.6666666666666667, "minX": 1.78884108E12, "maxY": 81.66666666666667, "series": [{"data": [[1.78884108E12, 1.6666666666666667]], "isOverall": false, "label": "Transaction-success", "isController": false}, {"data": [[1.78884108E12, 81.66666666666667]], "isOverall": false, "label": "Transaction-failure", "isController": false}], "supportsControllersDiscrimination": true, "granularity": 60000, "maxX": 1.78884108E12, "title": "Total Transactions Per Second"}},
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

