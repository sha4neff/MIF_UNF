#Область СлужебныйПрограммныйИнтерфейс

#Область РазборКодаМаркировки

// Выполняет разбор кода маркировки.
//
// Параметры:
//   ДанныеДляРазбора - Строка, см. МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1 - код маркировки, либо данные разбора.
//   ВидыПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Массив из ПеречислениеСсылка.ВидыПродукцииИС - фильтр по виду продукции.
//   ПримечаниеКРезультатуРазбора - Структура - содержит:
//      * ИдентификаторОшибки - см. РазборКодаМаркировкиИССлужебныйКлиентСервер.ИдентификаторыОшибокРазобраКодаМаркировки
//      * ТекстОшибки - Строка
//      * РезультатРазбора - Массив из см. РазборКодаМаркировкиИССлужебныйКлиентСервер.НастройкиРазбораКодаМаркировки
//   Настройки - см. РазборКодаМаркировкиИССлужебныйКлиентСервер.НастройкиРазбораКодаМаркировки.
//
// Возвращаемое значение:
//    - см. РазборКодаМаркировкиИССлужебныйКлиентСервер.НовыйРезультатРазбораКодаМаркировки.
//    - Неопределено - если код маркировки разобрать не удалось.
//
Функция РазобратьКодМаркировки(Знач ДанныеДляРазбора, ВидыПродукции = Неопределено, ПримечаниеКРезультатуРазбора = Неопределено, Знач Настройки = Неопределено, ПроверятьАлфавитЭлементов = Истина) Экспорт
	
	Возврат РазборКодаМаркировкиИССлужебныйКлиентСервер.РазобратьКодМаркировки(
		ДанныеДляРазбора, ВидыПродукции, ПримечаниеКРезультатуРазбора, Настройки, ПроверятьАлфавитЭлементов, РазборКодаМаркировкиИССлужебный);
	
КонецФункции

#КонецОбласти

#Область НастройкиРазбораКодаМаркировки

// Формирует настройки разбора кода маркировки по учитываемым видам продукции
//
// Параметры:
//   ТолькоСервер - Булево - Служебный параметр. Определяет контекст возможного использования настроек. Если передать Истина, то на клиент нельзя будет перенести настройки.
//   ВидыПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Массив из ПеречислениеСсылка.ВидыПродукцииИС - Служебный параметр. Фильтр по виду продукции.
//
// Возвращаемое значение:
//    Структура:
//     * ДоступныеВидыПродукции - см. ИнтеграцияИС.УчитываемыеВидыМаркируемойПродукции().
//     * Алфавит - см. РазборКодаМаркировкиИССлужебныйКлиентСервер.ДопустимыеСимволыВКодеМаркировки().
//     * ИменаОбщихМодулей - Массив из Строка.
//     * ШаблоныКодовМаркировкиПоВидамПродукции - Массив из Структура.
//     * ШаблоныКодовМаркировки - Массив из Структура.
//     * ШаблоныИОписанияВидовПродукции - Соответствие.
//     * ДополнительныеПараметры - Структура.
//     * ТолькоСервер - Булево.
//
Функция НастройкиРазбораКодаМаркировки(ТолькоСервер = Ложь, ВидыПродукции = Неопределено) Экспорт
	
	НастройкиРазбораКодаМаркировки = ИнициализацияНастроекРазбораКодаМаркировки();
	НастройкиРазбораКодаМаркировки.Алфавит      = РазборКодаМаркировкиИССлужебныйКлиентСервер.ДопустимыеСимволыВКодеМаркировки();
	НастройкиРазбораКодаМаркировки.ТолькоСервер = ТолькоСервер;
	
	УчитываемыеВидыМаркируемойПродукции = ИнтеграцияИС.УчитываемыеВидыМаркируемойПродукции();
	
	Если УчитываемыеВидыМаркируемойПродукции.Количество() = 0 Тогда
		Возврат НастройкиРазбораКодаМаркировки;
	КонецЕсли;
	
	Если ВидыПродукции = Неопределено Тогда
		
		ДоступныеВидыПродукции = УчитываемыеВидыМаркируемойПродукции;
		
	Иначе
		
		ДоступныеВидыПродукции = Новый Массив;
		
		ВидыПродукцииДляФильтра = Новый Массив;
		Если ЗначениеЗаполнено(ВидыПродукции) И ТипЗнч(ВидыПродукции) = Тип("ПеречислениеСсылка.ВидыПродукцииИС") Тогда
			ВидыПродукцииДляФильтра.Добавить(ВидыПродукции);
		ИначеЕсли ЗначениеЗаполнено(ВидыПродукции) И ТипЗнч(ВидыПродукции) = Тип("Массив") Тогда
			Для Каждого Значение Из ВидыПродукции Цикл
				Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("ПеречислениеСсылка.ВидыПродукцииИС") Тогда
					ВидыПродукцииДляФильтра.Добавить(Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ВидыПродукцииДляФильтра.Количество() = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Фильтр по виду продукции в настройках разбора кода маркировки задан не верно.'");
		КонецЕсли;
		
		ВидыПродукцииДляФильтра = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВидыПродукцииДляФильтра);
		
		Для Каждого ВидПродукции Из ВидыПродукцииДляФильтра Цикл
			Если УчитываемыеВидыМаркируемойПродукции.Найти(ВидПродукции) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ДоступныеВидыПродукции.Добавить(ВидПродукции);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДоступныеВидыПродукции.Количество() = 0 Тогда
		Возврат НастройкиРазбораКодаМаркировки;
	КонецЕсли;
	
	НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции = ДоступныеВидыПродукции;
	
	ДанныеОбщихМодулей                = Новый Соответствие;
	ДанныеОбщихМодулейПоВидуПродукции = Новый Соответствие;
	
	МодулиПодсистемыЕГАИС = Неопределено;
	МодулиПодсистемыИСМП  = Неопределено;
	
	Для Каждого ВидПродукции Из НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции Цикл
		
		Если ВидПродукции = Перечисления.ВидыПродукцииИС.Алкогольная Тогда
			
			Если МодулиПодсистемыЕГАИС = Неопределено Тогда
				
				Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ЕГАИС") Тогда
					МодульНастройки = "РазборКодаМаркировкиЕГАИССлужебный";
					МодульРазбораКМ = "РазборКодаМаркировкиЕГАИССлужебныйКлиентСервер";
					
					ДанныеМодуляНастройки = Новый Структура("Имя, ОбщийМодуль", МодульНастройки, ОбщегоНазначения.ОбщийМодуль(МодульНастройки));
					ДанныеМодуляРазбора   = Новый Структура("Имя, ОбщийМодуль", МодульРазбораКМ, ОбщегоНазначения.ОбщийМодуль(МодульРазбораКМ));
					
					МодулиПодсистемыЕГАИС = Новый Структура("Подсистема, Настройка, Разбор", "ЕГАИС", ДанныеМодуляНастройки, ДанныеМодуляРазбора);
				КонецЕсли;
				
			КонецЕсли;
			МодулиВыбраннойПодсистемы = МодулиПодсистемыЕГАИС;
			
		Иначе
			
			Если МодулиПодсистемыИСМП = Неопределено Тогда
				
				Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
					МодульНастройки = "РазборКодаМаркировкиИСМПСлужебный";
					МодульРазбораКМ = "РазборКодаМаркировкиИСМПСлужебныйКлиентСервер";
					
					ДанныеМодуляНастройки = Новый Структура("Имя, ОбщийМодуль", МодульНастройки, ОбщегоНазначения.ОбщийМодуль(МодульНастройки));
					ДанныеМодуляРазбора   = Новый Структура("Имя, ОбщийМодуль", МодульРазбораКМ, ОбщегоНазначения.ОбщийМодуль(МодульРазбораКМ));
					
					МодулиПодсистемыИСМП = Новый Структура("Подсистема, Настройка, Разбор", "ИСМП", ДанныеМодуляНастройки, ДанныеМодуляРазбора);
				КонецЕсли;
				
			КонецЕсли;
			МодулиВыбраннойПодсистемы = МодулиПодсистемыИСМП;
			
		КонецЕсли;
		
		Если МодулиВыбраннойПодсистемы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеОбщихМодулей[МодулиВыбраннойПодсистемы.Подсистема] = Неопределено Тогда
			ДанныеОбщихМодулей[МодулиВыбраннойПодсистемы.Подсистема] = МодулиВыбраннойПодсистемы;
			НастройкиРазбораКодаМаркировки.ОбщиеМодули[МодулиВыбраннойПодсистемы.Разбор.Имя] = МодулиВыбраннойПодсистемы.Разбор.ОбщийМодуль;
		КонецЕсли;
		
		МодулиВыбраннойПодсистемы.Настройка.ОбщийМодуль.ДополнитьНастройкиРазбораКодаМаркировки(НастройкиРазбораКодаМаркировки, ВидПродукции, МодулиВыбраннойПодсистемы.Разбор);
		
		ДанныеОбщихМодулейПоВидуПродукции[ВидПродукции] = МодулиВыбраннойПодсистемы;
		
	КонецЦикла;
	
	// Определяем порядок вызываемых проверок при разборе кода маркировки
	Если МодулиПодсистемыИСМП <> Неопределено Тогда
		НастройкиРазбораКодаМаркировки.ИменаОбщихМодулей.Добавить(МодулиПодсистемыИСМП.Разбор.Имя);
	КонецЕсли;
	Если МодулиПодсистемыЕГАИС <> Неопределено Тогда
		НастройкиРазбораКодаМаркировки.ИменаОбщихМодулей.Добавить(МодулиПодсистемыЕГАИС.Разбор.Имя);
	КонецЕсли;
	
	ИменаКолонок                             = Новый Массив;
	ИменаКолонокБезВидаПродукцииВидаУпаковки = Новый Массив;
	Для Каждого КолонкаТаблици Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Колонки Цикл
		ИменаКолонок.Добавить(КолонкаТаблици.Имя);
		Если Не (КолонкаТаблици.Имя = "ВидПродукции" Или КолонкаТаблици.Имя = "ВидУпаковки") Тогда
			ИменаКолонокБезВидаПродукцииВидаУпаковки.Добавить(КолонкаТаблици.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Сворачиваем строки что бы исключить дубли
	ИменаКолонокСтрокой = СтрСоединить(ИменаКолонок, ",");
	НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Свернуть(ИменаКолонокСтрокой);
	
	// Сворачиваем строки без учета Вида продукции и Вида Упаковки
	ИменаКолонокСтрокой = СтрСоединить(ИменаКолонокБезВидаПродукцииВидаУпаковки, ",");
	ШаблоныКодовМаркировки = НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Скопировать(, ИменаКолонокСтрокой);
	ШаблоныКодовМаркировки.Свернуть(ИменаКолонокСтрокой);
	
	ШаблоныКодовМаркировки.Сортировать("ДлинаСоСкобкой, Длина");
	
	// Восстановим колонки ВидПродукции и ВидУпаковки
	Для Каждого ИмяКолонки Из СтрРазделить("ВидПродукции,ВидУпаковки", ",") Цикл
		КолонкаТаблици = НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Колонки[ИмяКолонки];
		ШаблоныКодовМаркировки.Колонки.Добавить(КолонкаТаблици.Имя, КолонкаТаблици.ТипЗначения);
	КонецЦикла;
	Для Каждого ШаблонКМ Из ШаблоныКодовМаркировки Цикл
		ДанныеШаблона = НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции[ШаблонКМ.Шаблон];
		Если ДанныеШаблона.ВидыПродукции.Количество() = 1 Тогда
			ШаблонКМ.ВидПродукции = ДанныеШаблона.ВидыПродукции[0];
		КонецЕсли;
		Если ДанныеШаблона.ВидыУпаковок.Количество() = 1 Тогда
			ШаблонКМ.ВидУпаковки = ДанныеШаблона.ВидыУпаковок[0];
		КонецЕсли;
	КонецЦикла;
	
	НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки = ШаблоныКодовМаркировки;
	
	ОпределитьОбщиеМодулиВШаблонахИОписанияхВидовПродукции(НастройкиРазбораКодаМаркировки, ДанныеОбщихМодулейПоВидуПродукции);
	
	Для Каждого ВидПродукции Из НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции Цикл
		МодулиВыбраннойПодсистемы = ДанныеОбщихМодулейПоВидуПродукции[ВидПродукции];
		
		Если Не НастройкиРазбораКодаМаркировки.ДополнительныеПараметры.Свойство(МодулиВыбраннойПодсистемы.Подсистема) Тогда
			НастройкиРазбораКодаМаркировки.ДополнительныеПараметры.Вставить(МодулиВыбраннойПодсистемы.Подсистема, Новый Структура);
		КонецЕсли;
		
		МодулиВыбраннойПодсистемы.Настройка.ОбщийМодуль.ДополнитьВспомогательнымиНастройкиРазбораКодаМаркировки(НастройкиРазбораКодаМаркировки, ВидПродукции, МодулиВыбраннойПодсистемы);
	КонецЦикла;
	
	Если Не НастройкиРазбораКодаМаркировки.ТолькоСервер Тогда
		
		// Конвертируем таблицы значений в массивы структур
		ШаблоныКодовМаркировкиПоВидамПродукции = Новый Массив;
		Для Каждого ШаблонКМ Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции Цикл
			ШаблоныКодовМаркировкиПоВидамПродукции.Добавить(
				ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ШаблонКМ));
		КонецЦикла;
		
		ШаблоныКодовМаркировки = Новый Массив;
		Для Каждого ШаблонКМ Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки Цикл
			ШаблоныКодовМаркировки.Добавить(
				ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ШаблонКМ));
		КонецЦикла;
		
		НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции = ШаблоныКодовМаркировкиПоВидамПродукции;
		НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки                 = ШаблоныКодовМаркировки;
		
		НастройкиРазбораКодаМаркировки.ОбщиеМодули = Новый Соответствие;
		
	КонецЕсли;
	
	Возврат НастройкиРазбораКодаМаркировки;
	
КонецФункции

Функция ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой) Экспорт
	
	СписокОписанийШаблонов = Новый Массив;
	
	Для Каждого ШаблонСтрокой Из ШаблоныСтрокой Цикл
		
		ОписаниеШаблонаКМ = Новый Массив;
		
		СписокЭлементовКМ = СтрРазделить(ШаблонСтрокой, "+", Ложь);
		Для Каждого ИмяЭлементаКМ Из СписокЭлементовКМ Цикл
			
			ОписаниеЭлементаКМ = ОписаниеЭлементовКМ[СокрЛП(ИмяЭлементаКМ)];
			
			ОписаниеШаблонаКМ.Добавить(ОписаниеЭлементаКМ);
			
		КонецЦикла;
		
		СписокОписанийШаблонов.Добавить(ОписаниеШаблонаКМ);
		
	КонецЦикла;
	
	Возврат СписокОписанийШаблонов;
	
КонецФункции

// Формирует описание элемента для кода маркировки
// 
// Параметры:
// 	Код - Строка - Код элемента.
// 	Имя - Строка - Имя элемента.
// 	КоличествоЗнаков - Число - Число знаков.
// 	АлфавитДопустимыхСимволов - Строка - Если заполнено, то определяет какими символами может быть заполнено значение элемента.
// Возвращаемое значение:
// 	Структура - описание элемента для кода маркировки:
// * Код - Строка - Код элемента.
// * Имя - Строка - Имя элемента.
// * Длина - Число - Число знаков.
// * Алфавит - Строка - Если заполнено, то определяет какими символами может быть заполнено значение элемента.
Функция ОписаниеЭлементаКодаМаркировки(Код, Имя, КоличествоЗнаков, АлфавитДопустимыхСимволов = "") Экспорт
	ОписаниеКода = Новый Структура;
	ОписаниеКода.Вставить("Код",     Код);
	ОписаниеКода.Вставить("Имя",     Имя);
	ОписаниеКода.Вставить("Длина",   КоличествоЗнаков);
	ОписаниеКода.Вставить("Алфавит", АлфавитДопустимыхСимволов);
	Возврат ОписаниеКода;
КонецФункции

Процедура ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки) Экспорт
	
	ВидПродукции                  = НастройкаОписанияКодаМаркировки.ВидПродукции;
	ОписаниеШаблонаКодаМаркировки = НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки;
	ТипШтрихкодаИВидУпаковки      = НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки;
	
	НачинаетсяСоСкобки  = Ложь;
	ДлинаКодаМаркировки = 0;
	
	СтрокиШаблона = Новый Массив;
	
	КоличествоЭлементов = ОписаниеШаблонаКодаМаркировки.Количество();
	Для ТекущийИндекс = 0 По КоличествоЭлементов - 1 Цикл
		
		ОписаниеЭлементаКМ = ОписаниеШаблонаКодаМаркировки[ТекущийИндекс];
		
		Если ТекущийИндекс = 0 Тогда
			НачинаетсяСоСкобки = ЗначениеЗаполнено(ОписаниеЭлементаКМ.Код);
			КодПервогоЭлемента = ОписаниеЭлементаКМ.Код;
		КонецЕсли;
		
		ДлинаКодаМаркировки = ДлинаКодаМаркировки + СтрДлина(ОписаниеЭлементаКМ.Код) + ОписаниеЭлементаКМ.Длина;
		
		Если ТекущийИндекс > 0 Тогда
			СтрокиШаблона.Добавить("+");
		КонецЕсли;
		
		Если НачинаетсяСоСкобки Тогда
			СтрокиШаблона.Добавить(СтрШаблон("%1 + %2 (%3 chars)",
				ОписаниеЭлементаКМ.Код, ОписаниеЭлементаКМ.Имя, ОписаниеЭлементаКМ.Длина));
		Иначе
			СтрокиШаблона.Добавить(СтрШаблон("%1 (%2 chars)",
				ОписаниеЭлементаКМ.Имя, ОписаниеЭлементаКМ.Длина));
		КонецЕсли;
		
	КонецЦикла;
	
	Шаблон = СтрСоединить(СтрокиШаблона, " ");
	
	ДлинаКодаМаркировкиСоСкобкой = 0;
	Если НачинаетсяСоСкобки Тогда
		ДлинаКодаМаркировкиСоСкобкой = ДлинаКодаМаркировки + КоличествоЭлементов * 2;
	КонецЕсли;
	
	ШаблонКМ = НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Добавить();
	ШаблонКМ.ВидПродукции        = ВидПродукции;
	ШаблонКМ.Шаблон              = Шаблон;
	ШаблонКМ.ТипШтрихкода        = ТипШтрихкодаИВидУпаковки.ТипШтрихкода;
	ШаблонКМ.ВидУпаковки         = ТипШтрихкодаИВидУпаковки.ВидУпаковки;
	ШаблонКМ.КоличествоЭлементов = КоличествоЭлементов;
	ШаблонКМ.НачинаетсяСоСкобки  = НачинаетсяСоСкобки;
	ШаблонКМ.Длина               = ДлинаКодаМаркировки;
	ШаблонКМ.ДлинаСоСкобкой      = ДлинаКодаМаркировкиСоСкобкой;
	ШаблонКМ.КодПервогоЭлемента  = КодПервогоЭлемента;
	
	ЗаполнениеШаблоновИОписанийВидовПродукции(НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции, НастройкаОписанияКодаМаркировки, Шаблон, НачинаетсяСоСкобки);
	
КонецПроцедуры

Функция НастройкиОписанияШаблонаКодаМаркировкиВидаПродукции() Экспорт
	Возврат Новый Структура(
		"ВидПродукции, ТипШтрихкодаИВидУпаковки, СоставКодаМаркировки, ОписаниеШаблонаКодаМаркировки, ДанныеОбщегоМодуля");
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиРазбораКодаМаркировки

Процедура ОпределитьОбщиеМодулиВШаблонахИОписанияхВидовПродукции(НастройкиРазбораКодаМаркировки, ДанныеОбщихМодулейПоВидуПродукции)
	
	Для Каждого СтрокаПоискаШаблона Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки Цикл
		
		ДанныеШаблона      = НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции[СтрокаПоискаШаблона.Шаблон];
		ДанныеОбщихМодулей = Новый Соответствие;
		
		Для Каждого ВидПродукции Из ДанныеШаблона.ВидыПродукции Цикл
			
			МодулиВыбраннойПодсистемы = ДанныеОбщихМодулейПоВидуПродукции[ВидПродукции];
			
			Если ДанныеОбщихМодулей[МодулиВыбраннойПодсистемы.Подсистема] = Неопределено Тогда
				
				ДанныеОбщихМодулей[МодулиВыбраннойПодсистемы.Подсистема] = МодулиВыбраннойПодсистемы;
				
				ДанныеШаблона.ИменаОбщихМодулей.Добавить(МодулиВыбраннойПодсистемы.Разбор.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Контсруктор настроек разбора кода маркировки.
//
// Возвращаемое значение:
//    Структура:
//     * ДоступныеВидыПродукции - Массив.
//     * Алфавит - Структура.
//     * ИменаОбщихМодулей - Массив.
//     * ШаблоныКодовМаркировкиПоВидамПродукции - ТаблицаЗначений.
//     * ШаблоныКодовМаркировки - ТаблицаЗначений.
//     * ШаблоныИОписанияВидовПродукции - Соответствие.
//     * ДополнительныеПараметры - Структура.
//
Функция ИнициализацияНастроекРазбораКодаМаркировки()
	
	ШаблоныКодовМаркировки = Новый ТаблицаЗначений;
	ШаблоныКодовМаркировки.Колонки.Добавить("Шаблон",              Новый ОписаниеТипов("Строка"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ТипШтрихкода",        Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодов"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ВидУпаковки",         Новый ОписаниеТипов("ПеречислениеСсылка.ВидыУпаковокИС"));
	ШаблоныКодовМаркировки.Колонки.Добавить("КоличествоЭлементов", Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("НачинаетсяСоСкобки",  Новый ОписаниеТипов("Булево"));
	ШаблоныКодовМаркировки.Колонки.Добавить("Длина",               Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ДлинаСоСкобкой",      Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("КодПервогоЭлемента",  Новый ОписаниеТипов("Строка"));
	
	ШаблоныКодовМаркировкиПоВидамПродукции = ШаблоныКодовМаркировки.СкопироватьКолонки();
	ШаблоныКодовМаркировкиПоВидамПродукции.Колонки.Добавить("ВидПродукции", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыПродукцииИС"));
	
	Настройки = Новый Структура;
	Настройки.Вставить("ДоступныеВидыПродукции",                 Новый Массив);
	Настройки.Вставить("Алфавит",                                Новый Структура);
	Настройки.Вставить("ИменаОбщихМодулей",                      Новый Массив);
	Настройки.Вставить("ОбщиеМодули",                            Новый Соответствие); // Когда ТолькоСервер = Ложь, тогда очищается.
	Настройки.Вставить("ШаблоныКодовМаркировкиПоВидамПродукции", ШаблоныКодовМаркировкиПоВидамПродукции); // Когда ТолькоСервер = Ложь, тогда конвертируется в массив структур
	Настройки.Вставить("ШаблоныКодовМаркировки",                 ШаблоныКодовМаркировки); // Когда ТолькоСервер = Ложь, тогда конвертируется в массив структур
	Настройки.Вставить("ШаблоныИОписанияВидовПродукции",         Новый Соответствие);
	Настройки.Вставить("ДополнительныеПараметры",                Новый Структура);
	Настройки.Вставить("ТолькоСервер",                           Ложь);
	
	Возврат Настройки;
	
КонецФункции

// Заполняет и дополняет соответствие ШаблоныИОписанияВидовПродукции из настроек разбора кода маркировки
//
// Параметры:
//   ШаблоныИОписанияВидовПродукции  - Соответствие - НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции.
//   НастройкаОписанияКодаМаркировки - см. РазборКодаМаркировкиИССлужебный.НастройкиОписанияШаблонаКодаМаркировкиВидаПродукции.
//   Шаблон                          - Строка - Пример: [Data matrix] ШтрихкодАкцизнойМарки (150 chars).
//   НачинаетсяСоСкобки              - Булево - Наличие идентификаторов применения в шаблоне кода маркировки.
//
Процедура ЗаполнениеШаблоновИОписанийВидовПродукции(ШаблоныИОписанияВидовПродукции, НастройкаОписанияКодаМаркировки, Шаблон, НачинаетсяСоСкобки)
	
	// Формируем описание и состав кода маркировки в соответствии с составом текущего шаблона
	ОписаниеТекущегоШаблона = ШаблоныИОписанияВидовПродукции[Шаблон];
	Если ОписаниеТекущегоШаблона = Неопределено Тогда
		
		СоставКодаМаркировки           = РазборКодаМаркировкиИССлужебныйКлиентСервер.СкопироватьСоставКодаМаркировки(НастройкаОписанияКодаМаркировки.СоставКодаМаркировки);
		ОписаниеШаблонаКодаМаркировки  = НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки;
		ПозицииЭлементовКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПозицииЭлементовВШаблонеКодаМаркировки(ОписаниеШаблонаКодаМаркировки);
		
		ОписаниеТекущегоШаблона = Новый Структура;
		ОписаниеТекущегоШаблона.Вставить("ВидыПродукции",                   Новый Массив);
		ОписаниеТекущегоШаблона.Вставить("ВидыУпаковок",                    Новый Массив);
		ОписаниеТекущегоШаблона.Вставить("ВидыУпаковокПоВидамПродукции",    Новый Соответствие);
		ОписаниеТекущегоШаблона.Вставить("ОписаниеЭлементовКодаМаркировки", ОписаниеШаблонаКодаМаркировки);
		ОписаниеТекущегоШаблона.Вставить("ПозицииЭлементовКодаМаркировки",  ПозицииЭлементовКодаМаркировки);
		ОписаниеТекущегоШаблона.Вставить("НачинаетсяСоСкобки",              НачинаетсяСоСкобки);
		ОписаниеТекущегоШаблона.Вставить("СоставКодаМаркировки",            СоставКодаМаркировки);
		ОписаниеТекущегоШаблона.Вставить("ИменаОбщихМодулей",               Новый Массив);
		
		ШаблоныИОписанияВидовПродукции[Шаблон] = ОписаниеТекущегоШаблона;
		
	КонецЕсли;
	
	ВидПродукции = НастройкаОписанияКодаМаркировки.ВидПродукции;
	ВидУпаковки  = НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки.ВидУпаковки;
	
	ВидыУпаковокПоВидамПродукции = ОписаниеТекущегоШаблона.ВидыУпаковокПоВидамПродукции[ВидПродукции];
	Если ВидыУпаковокПоВидамПродукции = Неопределено Тогда
		
		ОписаниеТекущегоШаблона.ВидыПродукции.Добавить(ВидПродукции);
		
		ВидыУпаковокПоВидамПродукции = Новый Массив;
		ВидыУпаковокПоВидамПродукции.Добавить(ВидУпаковки);
		ОписаниеТекущегоШаблона.ВидыУпаковокПоВидамПродукции[ВидПродукции] = ВидыУпаковокПоВидамПродукции;
		
	ИначеЕсли ВидыУпаковокПоВидамПродукции.Найти(ВидУпаковки) = Неопределено Тогда
		
		ВидыУпаковокПоВидамПродукции.Добавить(ВидУпаковки);
		
	КонецЕсли;
	
	Если ОписаниеТекущегоШаблона.ВидыУпаковок.Найти(ВидУпаковки) = Неопределено Тогда
		ОписаниеТекущегоШаблона.ВидыУпаковок.Добавить(ВидУпаковки);
	КонецЕсли;
	
	// Переформируем состав один раз, так что бы подходил под любой вид продукции
	Если ОписаниеТекущегоШаблона.ВидыПродукции.Количество() = 2
		И ОписаниеТекущегоШаблона.СоставКодаМаркировки.Количество() > 0 Тогда
		
		ТребуетсяПереформироватьСоставКодаМаркировки = Ложь;
		// У табачной продукции и альтернативной табачной продукции один и тот же состав
		Для Каждого ВидПродукцииШаблона Из ОписаниеТекущегоШаблона.ВидыПродукции Цикл
			Если ИнтеграцияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукцииШаблона) Тогда
				ТребуетсяПереформироватьСоставКодаМаркировки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ТребуетсяПереформироватьСоставКодаМаркировки Тогда
			
			МодульРазбораКМ = НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля.ОбщийМодуль;
			НовыйСоставКодаМаркировки = МодульРазбораКМ.НовыйСоставКодаМаркировки(
				НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки);
			
			ОписаниеТекущегоШаблона.СоставКодаМаркировки = НовыйСоставКодаМаркировки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция МодульОбщегоНазначения() Экспорт
	Возврат ОбщегоНазначения;
КонецФункции

Функция ОбщийМодуль(Имя) Экспорт
	Возврат МодульОбщегоНазначения().ОбщийМодуль(Имя);
КонецФункции

Функция ЭтоСервер() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

#КонецОбласти