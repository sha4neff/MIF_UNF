
#Область ПрограммныйИнтерфейс

// Функция возвращает цвет, отличающийся от исходного светлотой
//
// Параметры:
//  Цвет			 - Цвет	 - исходный цвет
//  ДельтаСветлоты	 - Число - процент изменения светлоты цвета. Значение 100 белый цвет, -100 черный.
// 
// Возвращаемое значение:
//  Цвет - цвет с измененной светлотой
//
Функция ИзменитьСветлотуЦвета(знач Цвет, знач ДельтаСветлоты) Экспорт
	
	Если Цвет.Вид <> ВидЦвета.Абсолютный Тогда
		Возврат Цвет;
	КонецЕсли;
	
	Если ДельтаСветлоты >= 0 Тогда
		КрайнееЗначение = 255;
	Иначе
		КрайнееЗначение = 0;
	КонецЕсли;
	
	R = Цвет.Красный + ДельтаСветлоты * Макс(КрайнееЗначение - Цвет.Красный, Цвет.Красный - КрайнееЗначение) / 100;
	G = Цвет.Зеленый + ДельтаСветлоты * Макс(КрайнееЗначение-Цвет.Зеленый, Цвет.Зеленый - КрайнееЗначение) / 100;
	B = Цвет.Синий + ДельтаСветлоты * Макс(КрайнееЗначение-Цвет.Синий, Цвет.Синий - КрайнееЗначение) / 100;
	
	Возврат Новый Цвет(R, G, B);
	
КонецФункции

// Функция возвращает набор пастельных цветов в порядке их взаимной контрастности
// Возвращаемое значение:
//  Массив - массив цветов для использования в сериях на диаграммах
Функция ЦветаСерийДиаграмм() Экспорт
	
	МассивЦветов = Новый Массив;
	
	МассивЦветов.Добавить(Новый Цвет(245, 152, 150));
	МассивЦветов.Добавить(Новый Цвет(142, 201, 249));
	МассивЦветов.Добавить(Новый Цвет(255, 202, 125));
	МассивЦветов.Добавить(Новый Цвет(178, 154, 218));
	МассивЦветов.Добавить(Новый Цвет(163, 214, 166));
	МассивЦветов.Добавить(Новый Цвет(244, 140, 175));
	МассивЦветов.Добавить(Новый Цвет(125, 221, 233));
	МассивЦветов.Добавить(Новый Цвет(255, 242, 128));
	МассивЦветов.Добавить(Новый Цвет(205, 145, 215));
	МассивЦветов.Добавить(Новый Цвет(125, 202, 194));
	
	Возврат МассивЦветов;
	
КонецФункции

// Функция - Цвет по номеру картинки
//
// Параметры:
//  НомерКартинки	 - Число	 - номер картинки цвета из библиотеки картинок
// 
// Возвращаемое значение:
//  Цвет - цвет картинки
//
Функция ЦветПоНомеруКартинки(НомерКартинки) Экспорт
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить(1,  Новый Цвет(172,114,94));
	Соответствие.Вставить(2,  Новый Цвет(208,107,100));
	Соответствие.Вставить(3,  Новый Цвет(248,58,34));
	Соответствие.Вставить(4,  Новый Цвет(250,87,60));
	Соответствие.Вставить(5,  Новый Цвет(255,117,55));
	Соответствие.Вставить(6,  Новый Цвет(255,173,70));
	Соответствие.Вставить(7,  Новый Цвет(66,214,146));
	Соответствие.Вставить(8,  Новый Цвет(22,167,101));
	Соответствие.Вставить(9,  Новый Цвет(123,209,72));
	Соответствие.Вставить(10, Новый Цвет(179,220,108));
	Соответствие.Вставить(11, Новый Цвет(251,233,131));
	Соответствие.Вставить(12, Новый Цвет(250,209,101));
	Соответствие.Вставить(13, Новый Цвет(146,225,192));
	Соответствие.Вставить(14, Новый Цвет(159,225,231));
	Соответствие.Вставить(15, Новый Цвет(159,198,231));
	Соответствие.Вставить(16, Новый Цвет(73,134,231));
	Соответствие.Вставить(17, Новый Цвет(154,156,255));
	Соответствие.Вставить(18, Новый Цвет(185,154,255));
	Соответствие.Вставить(19, Новый Цвет(194,194,194));
	Соответствие.Вставить(20, Новый Цвет(202,189,191));
	Соответствие.Вставить(21, Новый Цвет(204,166,172));
	Соответствие.Вставить(22, Новый Цвет(246,145,178));
	Соответствие.Вставить(23, Новый Цвет(205,116,230));
	Соответствие.Вставить(24, Новый Цвет(164,122,226));
	
	Возврат Соответствие[НомерКартинки];
	
КонецФункции

// Функция - Картинка цвета по номеру картинки
//
// Параметры:
//  НомерКартинки	 - Число	 - номер картинки цвета из библиотеки картинок
// 
// Возвращаемое значение:
//  Картинка - картинка цвета из библиотеки картинок
//
Функция КартинкаЦветаПоНомеруКартинки(НомерКартинки) Экспорт
	
	НомерСтрокой = Формат(НомерКартинки, "ЧЦ=2; ЧВН=");
	
	Возврат БиблиотекаКартинок["Цвет" + НомерСтрокой];
	
КонецФункции

#КонецОбласти
