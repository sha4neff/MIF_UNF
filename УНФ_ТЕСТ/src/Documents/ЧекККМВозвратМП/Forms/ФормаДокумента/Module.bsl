#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	Если Объект.СуммаОплаты > 0 И Объект.СуммаКартой = 0 Тогда
		Объект.СуммаОплаты = Объект.СуммаДокумента;
	ИначеЕсли Объект.СуммаОплаты = 0 И Объект.СуммаКартой > 0 Тогда
		Объект.СуммаКартой = Объект.СуммаДокумента;
	КонецЕсли;
	ОбновитьЗаписиПоСтрокамТЧ();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВРежимеСинхронизации()
	
	//ЭтоРежимСборЗаявок = ОбменМобильноеПриложениеВызовСервера.ОбменВключен();
	//
	//Если ЭтоРежимСборЗаявок И Объект.СуммаСкидки = 0 Тогда
	//	Элементы.ГруппаВсегоВРежимеСинхронизации.Видимость = Ложь;
	//	Элементы.ГруппаВсего.Видимость = Истина;
	//Иначе
	//	Элементы.ГруппаВсегоВРежимеСинхронизации.Видимость = Истина;
	//	Элементы.ГруппаВсего.Видимость = Ложь;
	//КонецЕсли;
	//
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуОплатыЕслиНужно(СПредупреждением = Ложь)
	
	Если Объект.СуммаОплаты > (Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки) Тогда
		Если СПредупреждением Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("СкорректироватьСуммуОплатыЕслиНужноЗавершение", ЭтаФорма), НСтр("ru='Сумма оплаты не может быть больше суммы документа со скидкой!';en='Payment amount cannot be greater than the sum of the document at a discount!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		Объект.СуммаОплаты = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуОплатыЕслиНужноЗавершение(ДополнительныеПараметры) Экспорт
	
	Объект.СуммаОплаты = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужно(СПредупреждением = Ложь)
	
	Если Объект.СуммаСкидки > Объект.Товары.Итог("Сумма")Тогда
		Если СПредупреждением Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("СкорректироватьСуммуСкидкиЕслиНужноЗавершение", ЭтаФорма), НСтр("ru='Сумма скидки не может быть больше суммы документа!';en='Discount amount cannot be greater than the sum of the document!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	КонецЕсли;
	
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужноЗавершение(ДополнительныеПараметры) Экспорт
	
	Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентСкидки()
	
	ТоварыИтог = Объект.Товары.Итог("Сумма");
	Если ТоварыИтог <> 0 Тогда
		Скидка = Окр(Объект.СуммаСкидки / ТоварыИтог * 100, 0);
		ПроцентСкидки = Строка(Скидка) + "%";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Объект.СуммаОплаты = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеСервер Тогда
		Если НЕ ЗначениеЗаполнено(Объект.КассаККМ) Тогда
			Объект.КассаККМ = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("КассаККММобильногоПриложения");
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.КассаККМ)
			И НЕ ЗначениеЗаполнено(Объект.РозничнаяТочка) Тогда
			Объект.РозничнаяТочка = Объект.КассаККМ.РозничнаяТочка;
		КонецЕсли;
	#КонецЕсли
	
	УстановитьВидимостьПриемаОплаты();
	
	УстановитьВидимостьВРежимеСинхронизации();
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("ru='Чек ККТ на возврат';en='Return Retail Sales'"), "Мужской");
	ОбновитьЗаписиПоСтрокамТЧ();
	
	#Если МобильноеПриложениеСервер Тогда
		ОборудованиеПечатиМП = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПечати");
	#Иначе
		ОборудованиеПечатиМП = Неопределено;
	#КонецЕсли
	
	Если ЗначениеЗаполнено(ОборудованиеПечатиМП) Тогда
		Элементы.Номер.Видимость = Ложь;
		Элементы.НомерЧекаККТ.Видимость = Истина;
	Иначе
		Элементы.Номер.Видимость = Истина;
		Элементы.НомерЧекаККТ.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.СуммаКартой > 0 И Объект.СуммаОплаты = 0 Тогда
		Элементы.СуммаДокумента.Заголовок = НСтр("ru='ИТОГО на карту'");
		Элементы.Выдать.Видимость = Ложь;
	ИначеЕсли Объект.СуммаКартой = 0 И Объект.СуммаОплаты > 0 Тогда
		Элементы.СуммаДокумента.Заголовок = НСтр("ru='ИТОГО наличными'");
		Элементы.Выдать.Видимость = Ложь;
	Иначе
		Элементы.Выдать.Видимость = Истина;
	КонецЕсли;
	
	Если Объект.Статус = Перечисления.СтатусЧекаККММП.Пробит Тогда
		Элементы.ГруппаНиз.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьОтображениеНомера();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("ru='Чек ККТ на возврат';en='Return Retail Sales'"));
	ОбновитьЗаписиПоСтрокамТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменилосьКоличествоТовара");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ВстроенныеПокупкиКлиент.ЕстьПодписка() Then
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		Если ВРег(Метаданные.Имя) = ВРег("УправлениеНебольшойФирмойНаМобильном") Тогда
			Возврат;
		КонецЕсли;
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульСинхронизацияПушУведомленияМПУНФ = Вычислить("СинхронизацияПушУведомленияМПУНФ");
		// АПК:488-вкл
		Если ТипЗнч(МодульСинхронизацияПушУведомленияМПУНФ) = Тип("ОбщийМодуль") Тогда
			МодульСинхронизацияПушУведомленияМПУНФ.ОтправитьПушУведомление("001");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СуммаОплатыПриИзменении(Элемент)
	
	СкорректироватьСуммуОплатыЕслиНужно(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	СкорректироватьСуммуСкидкиЕслиНужно();
	СкорректироватьСуммуОплатыЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура НапечататьТоварныйЧек(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ПечатнаяФорма = СформироватьПечатнуюФорму();;
	ПечатнаяФорма.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	
	Возврат Документы.ЧекККММП.СформироватьПечатнуюФорму(Объект.Ссылка);
	
КонецФункции

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/tovarnye-dokumenty/kartochka-dokumenta-check/");
	// АПК:534-вкл
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РозничныеПродажиМПКлиент.ВыполнитьЗакрытиеИОткрытиеСменыЕслиНужно(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОплатыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	//Если ТипЗнч(РезультатЗакрытия) = Тип("Структура")
	//	И РезультатЗакрытия.Успешно Тогда
	//	Объект.СуммаОплаты = РезультатЗакрытия.СуммаОплаты;
	//	Объект.СуммаКартой = РезультатЗакрытия.СуммаКартой;
	//	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусЧекаККМ.Пробит");
	//	Если ЗначениеЗаполнено(РезультатЗакрытия.НомерЧека) Тогда
	//		Объект.НомерЧекаККМ = Строка(РезультатЗакрытия.НомерЧека);
	//	Иначе
	//		Объект.НомерЧекаККМ = "1";
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(РезультатЗакрытия.НомерСмены) Тогда
	//		Объект.НомерСменыККМ = Число(РезультатЗакрытия.НомерСмены);
	//	КонецЕсли;
	//	Объект.АдресЭП = РезультатЗакрытия.АдресEmailПокупателя;
	//	Объект.Телефон = РезультатЗакрытия.НомерТелефонаПокупателя;
	//	УстановитьВидимостьПриемаОплаты();
	//	ЗаписатьЧек();
	//КонецЕсли;
	
	Если РезультатЗакрытия = Неопределено
		И ЗакрыватьПоЗавершенииОплаты Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолучениеРезультатаПоПлатежнойСистеме(Сумма, РезультатОперацииПоПлатежнойСистеме) Экспорт
	
	Если НЕ РезультатОперацииПоПлатежнойСистеме.Успешно Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаписатьЧек();
	КонецЕсли;
	
	Если РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.Оплата")
		ИЛИ РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.ВозвратОплаты") Тогда
		
		ДобавитьОперациюПоПлатежнойСистеме(РезультатОперацииПоПлатежнойСистеме);
		Оповестить("ЗаписанЧек", Объект.Ссылка);
		
	ИначеЕсли РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.ОтменаОплаты") Тогда
		
		ДобавитьОперациюПоПлатежнойСистеме(РезультатОперацииПоПлатежнойСистеме);
		УдалитьОплатуПоПлатежнойКарте();
		Оповестить("ЗаписанЧек", Объект.Ссылка)
		
	КонецЕсли;
	
	//ЗаполнитьИнформациюОбОплате();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОперациюПоПлатежнойСистеме(РезультатОперации)
	
	ЧекОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ЧекККММП"));
	
	ЧекОбъект.КодАвторизации = РезультатОперации.КодАвторизации;
	ЧекОбъект.СсылочныйНомер = РезультатОперации.НомерСсылкиОперации;
	ЧекОбъект.НомерПлатежнойКарты = РезультатОперации.НомерКарты;
	ЧекОбъект.ДатаОперацииЭТ = РезультатОперации.ДатаОперации;
	ЧекОбъект.СлипЧек = Новый ХранилищеЗначения(РезультатОперации.СлипЧек, Новый СжатиеДанных(9));
	
	ЧекОбъект.Записать();
	ЭтаФорма.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОплатуПоПлатежнойКарте()
	
	Объект.КодАвторизации = Неопределено;
	Объект.СсылочныйНомер = Неопределено;
	Объект.НомерПлатежнойКарты = Неопределено;
	Объект.ДатаОперацииЭТ = Неопределено;
	Объект.СлипЧек = Неопределено;
	Объект.СуммаКартой = Неопределено;
	
	ЗаписатьЧек();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПриемаОплаты()
	
	//Если Объект.Статус = Перечисления.СтатусЧекаККМ.Пробит Тогда
	//	Элементы.ПриемОплаты.Видимость = Ложь;
	//	Элементы.Получено.Видимость = Истина;
	//Иначе
	//	Элементы.ПриемОплаты.Видимость = Истина;
	//	Элементы.Получено.Видимость = Ложь;
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(Константы.ОборудованиеПечати.Получить()) Тогда
	//	Элементы.ПолученоБезОборудования.Видимость = Ложь;
	//Иначе
	//	Элементы.ПриемОплаты.Видимость = Ложь;
	//	Элементы.Получено.Видимость = Ложь;
	//	Элементы.ПолученоБезОборудования.Видимость = Истина;
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйНомер() Экспорт
	
	ЧекОбъект = РеквизитФормыВЗначение("Объект");
	ЧекОбъект.УстановитьНовыйНомер();
	ЗначениеВРеквизитФормы(ЧекОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЧек(Отказ = Ложь) Экспорт
	
	РозничныеПродажиМПКлиент.ВыполнитьЗакрытиеИОткрытиеСменыЕслиНужно(ЭтаФорма, Отказ);
	Если НЕ Отказ Тогда
		СтруктураСДанными = Неопределено;
		Если НужноОбновитьФормуДокумента() Тогда
			СтруктураСДанными = Новый Структура ("Статус, СуммаДокумента, СуммаКартой, СуммаОплаты, СуммаСкидки, Телефон, АдресЭП", Объект.Статус, Объект.СуммаДокумента, Объект.СуммаКартой, Объект.СуммаОплаты ,Объект.СуммаСкидки, Объект.Телефон, Объект.АдресЭП);
			ЭтаФорма.Прочитать();
		КонецЕсли;
		ЗаписатьЧекНаСервере(СтруктураСДанными);
		ОбновитьЗаписиПоСтрокамТЧ();
		Оповестить("ЗаписанЧек");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЧекНаСервере(СтруктураСДанными)
	
	ЧекОбъект = РеквизитФормыВЗначение("Объект");
	ЧекОбъект.Дата = ТекущаяДата();
	Если СтруктураСДанными <> Неопределено Тогда
		ЧекОбъект.Статус = СтруктураСДанными.Статус;
		ЧекОбъект.СуммаДокумента = СтруктураСДанными.СуммаДокумента;
		ЧекОбъект.СуммаКартой = СтруктураСДанными.СуммаКартой;
		ЧекОбъект.СуммаОплаты = СтруктураСДанными.СуммаОплаты;
		ЧекОбъект.СуммаСкидки = СтруктураСДанными.СуммаСкидки;
		ЧекОбъект.Телефон = СтруктураСДанными.Телефон;
		ЧекОбъект.АдресЭП = СтруктураСДанными.АдресЭП;
	КонецЕсли;
	ЧекОбъект.Записать();
	ЗначениеВРеквизитФормы(ЧекОбъект, "Объект");
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСсылочныйНомер() Экспорт
	
	Возврат Объект.СсылочныйНомер;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаписьПоСтроке(Знач Строка, ИдентификаторСтроки = Неопределено)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		СтрокаТЧ = Строка;
	Иначе
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	КонецЕсли;
	
	ЗаписьПоСтроке = "%Цена% x %Количество%";
	
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Количество%", Формат(СтрокаТЧ.Количество, "ЧЦ=15; ЧДЦ=%ТочностьОтображенияКоличества%; ЧН=0; ЧРД=.; ЧГ=0"));
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Цена%",       Формат(СтрокаТЧ.Цена, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0"));
	СтрокаТЧ.ЗаписьПоСтроке = ЗаписьПоСтроке;
	
	СуммаПоСтроке = "=%Сумма%";
	СуммаПоСтроке = СтрЗаменить(СуммаПоСтроке, "%Сумма%",      Формат(СтрокаТЧ.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0"));
	СтрокаТЧ.СуммаПоСтроке = СуммаПоСтроке;
	
	НомерПоСтроке = "#%НомерСтроки%";
	НомерПоСтроке = СтрЗаменить(НомерПоСтроке, "%НомерСтроки%", Формат(СтрокаТЧ.НомерСтроки, "ЧЦ=15; ЧДЦ=%ТочностьОтображенияКоличества%; ЧН=0; ЧРД=.; ЧГ=0"));
	СтрокаТЧ.НомерПоСтроке = НомерПоСтроке;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаписиПоСтрокамТЧ()
	
	Для каждого СтрокаТЧ Из Объект.Товары Цикл
		ОбновитьЗаписьПоСтроке(СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьДанныеОплатыПоПлатежнойКартеЧекаПродажи() Экспорт
	
	Возврат Документы.ЧекККММП.ДанныеОплатыПоПлатежнойКарте(Объект.ЧекККМ);
	
КонецФункции

&НаКлиенте
Процедура ОформитьВозврат(Команда)
	
	РозничныеПродажиМПКлиент.Оплатить(ЭтаФорма, Команда, Истина);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыСтроки()
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	СтруктураПараметров.Вставить("НомерСтроки",         ТекущиеДанные.НомерСтроки);
	СтруктураПараметров.Вставить("Товар",               ТекущиеДанные.Товар);
	СтруктураПараметров.Вставить("Количество",          ТекущиеДанные.Количество);
	СтруктураПараметров.Вставить("Цена",                ТекущиеДанные.Цена);
	СтруктураПараметров.Вставить("Сумма",               ТекущиеДанные.Сумма);
	СтруктураПараметров.Вставить("Чек",                 Объект.Ссылка);
	СтруктураПараметров.Вставить("ТолькоПросмотрФормы", ЭтаФорма.ТолькоПросмотр);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыСтроки = ПолучитьПараметрыСтроки();
	
	Если ПараметрыСтроки <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ПараметрыСтроки.ИдентификаторСтроки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеИзменитьСтроку", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("ОбщаяФорма.РедактированиеСтрокиМП", ПараметрыСтроки, ЭтаФорма,,,,ОписаниеОповещения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОповещениеИзменитьСтроку(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
	 ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтроки = ДополнительныеПараметры.ИдентификаторСтроки;
	СтрокаТаблицы = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если Результат.Свойство("УдалитьСтроку") Тогда
		ИндексСтроки = Объект.Товары.Индекс(СтрокаТаблицы);
		Объект.Товары.Удалить(ИндексСтроки);
		Модифицированность = Истина;
	ИначеЕсли Результат.Свойство("Сохранить") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Результат);
		Модифицированность = Истина;
	КонецЕсли;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНомера()
	
	Если Константы.СинхронизацияВключенаМП.Получить() И Объект.НомерПодтвержден = Ложь Тогда
		ЭтаФорма.Элементы.НомерНеПодтвержденЦБ.Видимость = Истина;
		ЭтаФорма.Элементы.Номер.Видимость = Ложь;
	Иначе
		ЭтаФорма.Элементы.НомерНеПодтвержденЦБ.Видимость = Ложь;
		ЭтаФорма.Элементы.Номер.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НужноОбновитьФормуДокумента()
	
	СсылкаНаОбновленныйДокумент = Документы.ЧекККМВозвратМП.ПолучитьСсылку(Объект.Ссылка.УникальныйИдентификатор());
	Если СсылкаНаОбновленныйДокумент <> Неопределено Тогда
		Если СсылкаНаОбновленныйДокумент.НомерПодтвержден <> Объект.НомерПодтвержден Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти