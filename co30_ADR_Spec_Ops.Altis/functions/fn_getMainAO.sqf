/*
Author: ToxaBes
Description: return position of new AO.
Format: [] call QS_fnc_getMainAO;
*/
private ["_target", "_targets"];

// format: [name,                        [center x,y],            [[bunker x, bunker y, small dome z, big dome z],...]]
_targets = [
    ["Радиолокационная станция София",   [25133.029,21835.643],   [[25255.4,21124.9,0,0.2],[24458.3,21631.6,-0.2,0],[25562,21521,0,0],[25215.4,22283,0,0.2]]],    
    ["Исследовательский Центр",          [20948.438,19258.75],    [[20779.5,19306.3,0,0.2],[20852.2,19625.3,0,-0.3],[20108.1,19397.1,0,-1],[21708.2,19085.8,0,0]]],
    ["Ферес",                            [21688.604,7616.5811],   [[22235.5,7864.58,0,0],[21483.1,7678.38,0,0],[21108.7,7256.6,0,0],[21586.6,6922.5,0,-1.5]]],
    ["Замок Скопос",                     [11208.429,8717.1465],   [[11110.1,8247.61,-0.5,-1.6],[10337.3,8705.24,0,-0.5],[11200,8436.76,0,0]]],
    ["Электростанция Зароса",            [8259.749,10925.204],    [[8293.75,10701.4,-0.5,0],[7927.98,10633.9,-0.5,-0.4],[7654.95,10835.1,0,0]]],
    ["Завод",                            [6176.1187,16244.433],   [[5698.67,16222.9,0,0],[5988.42,16075.8,-0.5,0],[6110.58,15877.2,0,0]]],
    ["Сирта",                            [8632.1279,18284.725],   [[8661.86,18475.7,0,-1.2],[8418.59,18204,0,-0.5]]],
    ["Зарос",                            [9048.9561,11960.961],   [[9207.34,11460.9,0,0],[8829.74,12177,0,-0.8]]],
    ["Фрини",                            [14592.628,20862.242],   [[14477.7,20785,-0.5,-0.5],[14672.9,20427.9,0,0.5],[15339.2,20775.4,-0.2,0]]],
    ["Халкея",                           [20275.369,11711.881],   [[20934.4,11167.2,-0.5,-0.5],[20434,12008.8,-1,-1.4]]],
    ["Ветряки Аристи",                   [7157.333,21537.85],     [[6882.24,22203.9,-0.5,-1.3],[7907.98,21498.8,-0.5,0],[7547.68,20986,0.1,0]]],
    ["Свалка",                           [5857.3813,20086.076],   [[5917.2,20162.5,0,-1]]],
    ["Айос-Дионисиос",                   [9225.1191,15832.686],   [[8962.58,15462.8,0.5,0],[8938.1,16419,-0.5,0],[9040.5,16021.8,0,-0.5]]],
    ["Лимни",                            [20901.906,14626.314],   [[21095.9,14584.6,-0.2,-0.5],[20731.5,15005.2,-0.5,0],[21674.6,14675.7,-0.5,-0.2]]],
    ["Аликампос",                        [11131.306,14561.813],   [[11044.9,14424.6,-0.3,0],[10513.1,14589.9,-0.2,-0.8],[11396.8,14939.9,-0.5,0.1]]],
    ["Харкия",                           [18152.555,15324.857],   [[18166.1,15596.5,0.3,0],[17785.3,15193.1,-0.5,-1.7]]],
    ["Неохори",                          [12366.604,14522.63],    [[12420.6,14338.4,0,0],[12242,14407.4,-0.2,0]]], 
    ["Молос",                            [27006.6,23292.713],     [[27527.4,23189.8,-0.3,-0.5],[26960.6,23058.7,0,0],[26962.4,23364.3,-0.5,-0.1]]],
    ["Ветряки Дидимос",                  [18731.309,10203.442],   [[18903.2,9952.41,-0.5,0],[18309.2,10566,0,0]]],
    ["Панохори",                         [5096.0444,11247.382],   [[5498.92,10910.2,-0.4,-0.2]]],
    ["Стадион",                          [5479.6147,14988.666],   [[5475.37,14998.7,0,0],[5806.33,15195,-0.3,-0.5],[5262.18,14735.4,0,0]]],
    ["Негадес",                          [4812.9224,15981.76],    [[5189.36,16112.1,0,-0.2]]],
    ["Абдера",                           [9519.4053,20315.996],   [[9741.89,19932.5,-0.1,-0.8],[9905.57,19418.2,0.5,-0.1]]],
    ["Ореокастро",                       [4658.9946,21372.818],   [[4660.36,21763.3,-0.5,-1]]],
    ["Дорида",                           [19402.133,13249.993],   [[19169.1,13300.6,0,0],[19522.5,13552,-0.2,0],[19656.1,13385.9,-0.1,0]]],
    ["Аванпост Галати",                  [9958.9834,19353.648],   [[9905.57,19418.2,0.5,-0.1],[9741.89,19932.5,0.2,-0.5]]],
    ["Лесной массив Фрини",              [14160.364,22125.211],   [[14416.5,22474.7,-0.1,-0.5],[14509.6,22183.4,-0.5,-1],[13870.2,21647.4,-0.1,0]]],
    ["Лесной массив Нидасос",            [23926.236,22597.678],   [[23931.2,22904.7,0,-0.2],[23807.5,22226.6,-0.7,0]]],
    ["Электростанция Софии",             [25425.523,20338.957],   [[25220.9,20275.2,-0.1,0],[25471,20405.4,-0.5,0.4],[25032.2,20805.3,-0.1,-0.1]]],
    ["Солнечная ферма Гатолия",          [27076.51,21451.102],    [[27071.2,21424.7,-0.2,0],[26881.8,21456.5,-0.1,-0.5],[27456.4,21485.1,-0.1,-0.2]]],
    ["Аванпост Викос",                   [12300.185,8875.7148],   [[12593.5,8520.2,0,-1],[12082,8651.37,-0.3,0],[11723.6,9275.52,0,-2]]],
    ["Панагия",                          [20517.268,8867.3457],   [[19996.9,8414.38,-0.5,0],[20421.1,9094.2,0,0.6],[20632.1,8630.3,-0.4,-0.3]]],
    ["Аванпост Селакано",                [20085.924,6731.9531],   [[20025.5,7047.24,-0.5,-0.5],[20473.6,6921.61,-0.3,0.5],[19803.7,6366.22,-0.5,-1.5]]],
    ["Ветряки Фотиа",                    [4059.063,19228.834],    [[3819.99,18997.1,-0.5,-1.5],[4174.03,19474,-0.8,-2.6]]],
    ["Аванпост Дельфинаки",              [23572.367,21102.557],   [[23486.6,21146,0,0.3],[23258.5,20623.9,-0.1,-0.1],[23515,21344.6,0,-0.5]]],
    ["Атира",                            [14061.246,18762.041],   [[14257.7,18937.5,-0.5,-0.5],[13799.9,18743.6,0,-1],[14150,18654.7,0,0]]],
    ["Атанос",                           [3711.6782,10463.897],   [[3711.68,10463.9,-0.5,-0.5],[3361.49,10266.3,-0.2,-1.5],[3729.62,10194.8,-0.5,-0.7]]],
    ["Лакка",                            [12311.626,15726.512],   [[12212.3,15597.1,0,0.5],[12315.1,15802.8,-0.2,-0.2],[12501.3,15580.9,-0.4,-1]]],
    ["Пирсос",                           [9209.5273,19250.604],   [[9220.88,19322.7,0,-1],[9729.92,19464.9,-0.2,-1]]],
    ["Фаронаки",                         [16558.344,10857.823],   [[16549.4,10830.4,-0.5,-0.8],[16715.4,10982.6,0,-1],[16214.3,10534.2,0,-0.5]]],
    ["Парос",                            [20954.951,16961.014],   [[21112.3,16872.9,0.4,0.8],[21075.7,17118.5,-0.3,-0.5],[20798.7,16986.9,-0.3,-0.5]]],
    ["Родополи",                         [18842.477,16641.371],   [[18877.3,16469.4,-0.1,0.5],[18895.9,16724.1,-0.3,0.8],[18644.6,16587.6,-0.3,-1.4]]],
    ["Аэродром Молос",                   [26868.643,24482.734],   [[26221.5,24313.4,-0.3,-0.8],[26815.9,24629.1,0,-0.1],[27411.2,24218.6,0,0.3]]],
    ["Заброшенный отель",                [22033.143,21092.943],   [[21986,21233.1,-0.2,0],[22068.5,20609.9,-0.8,-1.6]]],
    ["Калитея",                          [18084.033,17711.547],   [[18022.5,17930.1,-0.2,0],[17649.1,18118.1,-0.2,-0.4],[17611.3,17278.4,0,-0.2]]],
    ["Орино",                            [10456.78,17261.453],    [[10368.7,17182.6,-0.6,-0.1],[10604.4,17127.1,-0.3,-0.2],[10397,17438.4,-0.2,-0.4]]],
    ["Корони",                           [11846.54,18407.166],    [[11609.9,18322.2,-0.2,-0.9],[11761.4,18329.3,0.1,-1],[11896,18527.3,-0.4,-0.4]]],
    ["Полиакко",                         [10905.729,13409.782],   [[10907.2,13532.4,0.3,-1.3],[11130.3,13305.2,-0.5,0]]],
    ["Айос-Константинос",                [4447.7959,17561.309],   [[4766.95,17732.7,-0.6,-1.3],[3747.12,17605.3,-0.3,-0.2]]],
    ["Фарос",                            [6935.834,22630.203],    [[6837.9,22293,0.2,0.2],[7331.6,22508.4,-0.8,-2.6]]],
    ["Аэродром Крия Нера",               [9137.5215,21481.791],   [[9137.52,21481.8,-0.1,0],[9188.19,21649.2,-0.2,0]]],
    ["Айос-Панайотис",                   [6999.2192,11649.816],   [[6994.74,11628.6,-0.5,0.7],[6860.94,11905.6,0.6,-1.1]]],
    ["Териса",                           [10676.902,12263.73],    [[10524.3,12255.4,-0.2,-0.5],[10612.5,12387.4,-0.2,-0.6]]],
    ["Сагониси",                         [13796.183,13030.959],   [[14122,12973.4,0.2,-0.5],[14210.9,12882.5,-0.3,-3],[13600.2,13109.1,0,0]]],
    ["Гори",                             [5489.8896,17941.082],   [[5542.61,18141.8,-0.1,0]]],
    ["Кавала",                           [3739.22,13007.9],       [[3187.82,12909.9,0.1,0],[3649.64,13117.6,-0.2,0]]],
    ["Аггелохори",                       [4100.32,13820.98],      [[4106.71,13746,-0.1,0.3],[4061.54,13416.8,-0.3,0.5]]],
    ["Нери",                             [4167.8,11798],          [[4480.11,11774.4,-0.2,-0.6],[3837.74,11772.4,0,-0.5],[4331.83,12045.5,-0.1,-0.8]]],
    ["Айос-Панайотис",                   [6402.78,12355.9],       [[6611.73,12595.8,0.1,-1.3],[6860.94,11905.6,0.6,-1.1]]],
    ["Пиргос",                           [16819.8,12713.7],       [[17078.8,12528.4,-0.1,0],[16921.4,12920.2,-0.2,-1.3]]]
];

_target = _targets call BIS_fnc_selectRandom;

_rareTargets = ["Молос","Аэродром Молос","Аванпост Селакано","Ветряки Аристи","Ветряки Дидимос","Электростанция Софии","Солнечная ферма Гатолия","Аэродром Крия Нера"];
if ((_target select 0) in _rareTargets) then {
    if (random 10 > 5) then {
        _target = _targets call BIS_fnc_selectRandom;
    };
};

_target