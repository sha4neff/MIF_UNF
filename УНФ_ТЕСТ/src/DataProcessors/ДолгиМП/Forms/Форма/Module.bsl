#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
Процедура СформироватьНаСервере(ТабДокумент, ДляОтправки = Ложь, НаПечать = Ложь)
	
	ЭтоСмартфон = ОбщегоНазначенияМПВызовСервера.ЭтоСмартфон();
	ИмяМакета = "";
	
	Если ДляОтправки Тогда
		ИмяМакета = "МакетДляОтправки";
	ИначеЕсли ЭтоСмартфон Тогда
		Если ОбщегоНазначенияМПСервер.ПолучитьОриентациюЭкрана() = ОриентацияСтраницы.Ландшафт Тогда
			ИмяМакета = "Макет";
		Иначе
			ИмяМакета = "МакетСмартфон";
		КонецЕсли;
	Иначе
		ИмяМакета = "Макет";
	КонецЕсли;
	Макет = Обработки.ДолгиМП.ПолучитьМакет(ИмяМакета);
	ТабДокумент.Очистить();
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(ЭтаФорма.ЭлементОтбора) Тогда
		Отбор.Вставить("Контрагент", ЭтаФорма.ЭлементОтбора);
	КонецЕсли;
	
	ОстаткиВзаиморасчетов = РегистрыНакопления.ВзаиморасчетыСКонтрагентамиМП.Остатки(, Отбор);
	
	Если НЕ ДляОтправки Тогда
		Если ОстаткиВзаиморасчетов.Количество() = 0 Тогда
			Элементы.Содержимое.Видимость = Ложь;
			Элементы.ДекорацияПустойОтчет.Видимость = Истина;
			Возврат;
		Иначе
			Элементы.Содержимое.Видимость = Истина;
			Элементы.ДекорацияПустойОтчет.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НаПечать Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("НазваниеОтчета");
		ОбластьМакета.Параметры.Период = ТекущаяДата();
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОстаткиВзаиморасчетов.Колонки.Добавить("НаименованиеКонтрагента");
	ОстаткиВзаиморасчетов.Колонки.Добавить("СуммаНашДолг");
	ОстаткиВзаиморасчетов.Колонки.Добавить("СуммаЕгоДолг");
	Для каждого СтрокаВзаиморасчетов Из ОстаткиВзаиморасчетов Цикл
		СтрокаВзаиморасчетов.НаименованиеКонтрагента = СтрокаВзаиморасчетов.Контрагент.Наименование;
		Если СтрокаВзаиморасчетов.Сумма > 0 Тогда
			СтрокаВзаиморасчетов.СуммаЕгоДолг = СтрокаВзаиморасчетов.Сумма;
		Иначе
			СтрокаВзаиморасчетов.СуммаНашДолг = -СтрокаВзаиморасчетов.Сумма;
		КонецЕсли;
	КонецЦикла;
	ОстаткиВзаиморасчетов.Сортировать("НаименованиеКонтрагента Возр");
	
	Если ГруппироватьПоКонтрагенту Тогда
		ТабДокумент.НачатьАвтогруппировкуСтрок();
	КонецЕсли;
	
	СераяСтрока = Ложь;
	Для каждого СтрокаВзаиморасчетов Из ОстаткиВзаиморасчетов Цикл
		
		ВзаиморасчетыСКонтрагентом = Новый ТаблицаЗначений;
		ВзаиморасчетыСКонтрагентом.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
		ВзаиморасчетыСКонтрагентом.Колонки.Добавить("Основание");
		ВзаиморасчетыСКонтрагентом.Колонки.Добавить("ЕгоДолг");
		ВзаиморасчетыСКонтрагентом.Колонки.Добавить("НашДолг");
		
		Если ГруппироватьПоКонтрагенту Тогда
			СераяСтрока = Ложь;
		КонецЕсли;
		
		СледующаяОбласть = ?(СераяСтрока, "Серая", "");
		СераяСтрока = НЕ СераяСтрока;
		
		Если ГруппироватьПоКонтрагенту Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаЗаголовокГруппы");
		Иначе
			ОбластьМакета = Макет.ПолучитьОбласть("Строка" + СледующаяОбласть);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтрокаВзаиморасчетов);
		ТабДокумент.Вывести(ОбластьМакета, 1, , Ложь);
		
		Если ГруппироватьПоКонтрагенту Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ПриходДенегМП.Ссылка КАК ПриходДенегСсылка
			|ИЗ
			|	Документ.ПриходДенегМП КАК ПриходДенегМП
			|ГДЕ
			|	ПриходДенегМП.Контрагент = &Контрагент
			|	И НЕ ПриходДенегМП.Основание В
			|				(ВЫБРАТЬ
			|					РасходТовараМП.Основание
			|				ИЗ
			|					Документ.РасходТовараМП КАК РасходТовараМП
			|				ГДЕ
			|					РасходТовараМП.Основание = ПриходДенегМП.Основание)";
			
			Запрос.УстановитьПараметр("Контрагент", СтрокаВзаиморасчетов.Контрагент);
			Результат = Запрос.Выполнить().Выгрузить();
			
			Для каждого Строка Из Результат Цикл
				ОснованиеДолга = Строка.ПриходДенегСсылка;
				НашДолг = ОснованиеДолга.Сумма;
				
				Если НашДолг <> 0 Тогда
					НоваяСтрока = ВзаиморасчетыСКонтрагентом.Добавить();
					НоваяСтрока.Дата = ОснованиеДолга.Дата;
					НоваяСтрока.Основание = ОснованиеДолга;
					НоваяСтрока.НашДолг = НашДолг;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ПриходТовараМП.Ссылка КАК ПриходТовараСсылка,
			|	NULL КАК РасходДенегСсылка
			|ИЗ
			|	Документ.ПриходТовараМП КАК ПриходТовараМП
			|ГДЕ
			|	ПриходТовараМП.Поставщик = &Поставщик
			|	И НЕ ПриходТовараМП.Ссылка В
			|				(ВЫБРАТЬ
			|					РасходДенегМП.Основание
			|				ИЗ
			|					Документ.РасходДенегМП КАК РасходДенегМП
			|				ГДЕ
			|					РасходДенегМП.Основание = ПриходТовараМП.Ссылка)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ПриходТовараМП.Ссылка,
			|	РасходДенегМП.Ссылка
			|ИЗ
			|	Документ.ПриходТовараМП КАК ПриходТовараМП
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходДенегМП КАК РасходДенегМП
			|		ПО (РасходДенегМП.Основание = ПриходТовараМП.Ссылка)
			|ГДЕ
			|	ПриходТовараМП.Поставщик = &Поставщик
			|	И ПриходТовараМП.СуммаДокумента <> РасходДенегМП.Сумма";
			
			Запрос.УстановитьПараметр("Поставщик", СтрокаВзаиморасчетов.Контрагент);
			Результат = Запрос.Выполнить().Выгрузить();
			
			Для каждого Строка Из Результат Цикл
				
				ОснованиеДолга = Строка.ПриходТовараСсылка;
				
				Если ЗначениеЗаполнено(Строка.РасходДенегСсылка) Тогда
					СуммаОплаты = Строка.РасходДенегСсылка.Сумма;
				Иначе
					СуммаОплаты = 0;
				КонецЕсли;
				
				НашДолг = ОснованиеДолга.СуммаДокумента - СуммаОплаты;
				
				Если НашДолг <> 0 Тогда
					НоваяСтрока = ВзаиморасчетыСКонтрагентом.Добавить();
					НоваяСтрока.Дата = ОснованиеДолга.Дата;
					НоваяСтрока.Основание = ОснованиеДолга;
					НоваяСтрока.НашДолг = НашДолг;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	РасходТовараМП.Ссылка КАК РасходТовараСсылка,
			|	NULL КАК ПриходДенегСсылка
			|ИЗ
			|	Документ.РасходТовараМП КАК РасходТовараМП
			|ГДЕ
			|	РасходТовараМП.Покупатель = &Покупатель
			|	И НЕ РасходТовараМП.Основание В
			|				(ВЫБРАТЬ
			|					ПриходДенегМП.Основание
			|				ИЗ
			|					Документ.ПриходДенегМП КАК ПриходДенегМП
			|				ГДЕ
			|					ПриходДенегМП.Основание = РасходТовараМП.Основание)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	РасходТовараМП.Ссылка,
			|	ПриходДенегМП.Ссылка
			|ИЗ
			|	Документ.ПриходДенегМП КАК ПриходДенегМП
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходТовараМП КАК РасходТовараМП
			|		ПО ПриходДенегМП.Основание = РасходТовараМП.Основание
			|ГДЕ
			|	РасходТовараМП.Покупатель = &Покупатель
			|	И ПриходДенегМП.Сумма <> РасходТовараМП.СуммаДокумента";
			
			Запрос.УстановитьПараметр("Покупатель", СтрокаВзаиморасчетов.Контрагент);
			Результат = Запрос.Выполнить().Выгрузить();
			Для каждого Строка Из Результат Цикл
				ОснованиеДолга = Строка.РасходТовараСсылка;
				Если ЗначениеЗаполнено(Строка.ПриходДенегСсылка) Тогда
					СуммаОплаты = Строка.ПриходДенегСсылка.Сумма
				Иначе
					СуммаОплаты = 0;
				КонецЕсли;
				
				ЕгоДолг = ОснованиеДолга.СуммаДокумента - СуммаОплаты;
				
				Если ЕгоДолг <> 0 Тогда
					НоваяСтрока = ВзаиморасчетыСКонтрагентом.Добавить();
					НоваяСтрока.Дата = ОснованиеДолга.Дата;
					НоваяСтрока.Основание = ОснованиеДолга;
					НоваяСтрока.ЕгоДолг = ЕгоДолг;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	РасходДенегМП.Ссылка КАК РасходДенегСсылка
			|ИЗ
			|	Документ.РасходДенегМП КАК РасходДенегМП
			|ГДЕ
			|	РасходДенегМП.Контрагент = &Контрагент
			|	И (РасходДенегМП.Основание = НЕОПРЕДЕЛЕНО
			|			ИЛИ РасходДенегМП.Основание = ЗНАЧЕНИЕ(Документ.ЗаказМП.ПустаяСсылка))";
			
			Запрос.УстановитьПараметр("Контрагент", СтрокаВзаиморасчетов.Контрагент);
			Запрос.УстановитьПараметр("Основание", Неопределено);
			Результат = Запрос.Выполнить().Выгрузить();
			
			Для каждого Строка Из Результат Цикл
				
				ОснованиеДолга = Строка.РасходДенегСсылка;
				ЕгоДолг = ОснованиеДолга.Сумма;
				
				Если ЕгоДолг <> 0 Тогда
					НоваяСтрока = ВзаиморасчетыСКонтрагентом.Добавить();
					НоваяСтрока.Дата = ОснованиеДолга.Дата;
					НоваяСтрока.Основание = ОснованиеДолга;
					НоваяСтрока.ЕгоДолг = ЕгоДолг;
				КонецЕсли;
				
			КонецЦикла;
			
			ВзаиморасчетыСКонтрагентом.Сортировать("Дата");
			Для каждого Строка Из ВзаиморасчетыСКонтрагентом Цикл
				СледующаяОбласть = ?(СераяСтрока, "Серая", "");
				СераяСтрока = НЕ СераяСтрока;
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаГруппировка" + СледующаяОбласть);
				ОбластьМакета.Параметры.Основание = Строка.Основание;
				ОбластьМакета.Параметры.ЕгоДолг   = Строка.ЕгоДолг;
				ОбластьМакета.Параметры.НашДолг   = Строка.НашДолг;
				ТабДокумент.Вывести(ОбластьМакета, 2, , Ложь);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ГруппироватьПоКонтрагенту Тогда
		ТабДокумент.ЗакончитьАвтогруппировкуСтрок();
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
	ОбластьМакета.Параметры.СуммаНашДолг = ОстаткиВзаиморасчетов.Итог("СуммаНашДолг");
	ОбластьМакета.Параметры.СуммаЕгоДолг = ОстаткиВзаиморасчетов.Итог("СуммаЕгоДолг");
	ТабДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(ВыбранноеЗначение)
	
	ЭтаФорма.ЭлементОтбора = ВыбранноеЗначение;
	СформироватьНаСервере(Содержимое);
	Элементы.ГруппаФильтр.Видимость = Истина;
	Элементы.ДекорацияФильтр.Заголовок = Строка(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьОтбор()
	
	ЭтаФорма.ЭлементОтбора = Неопределено;
	СформироватьНаСервере(Содержимое);
	Элементы.ГруппаФильтр.Видимость = Ложь;
	Элементы.ДекорацияФильтр.Заголовок = "";
	
КонецПроцедуры

&НаСервере
Процедура УстановитьГруппировкуПоКонтрагенту(Группировать)
	
	ЭтаФорма.ГруппироватьПоКонтрагенту = Группировать;
	
	Если ГруппироватьПоКонтрагенту Тогда
		Элементы.ГруппироватьПоКонтрагенту.ЦветФона = Новый Цвет(204, 192, 133);
	Иначе
		Элементы.ГруппироватьПоКонтрагенту.ЦветФона = Новый Цвет(245, 242, 221);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	УстановитьГруппировкуПоКонтрагенту(Константы.ДолгиГруппироватьПоКонтрагентуМП.Получить());
	Если Параметры.Свойство("ЭлементОтбора") Тогда
		УстановитьОтбор(Параметры.ЭлементОтбора);
	КонецЕсли;
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтрагентыМП") Тогда
		УстановитьОтбор(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Константы.ДолгиГруппироватьПоКонтрагентуМП.Установить(ЭтаФорма.ГруппироватьПоКонтрагенту);
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура Фильтр(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("ОтборПоКонтрагенту", НСтр("ru='Отбор по контрагенту';en='Filter by Customers & Suppliers'"));
	
	#Если МобильноеПриложениеКлиент Тогда
		ВидОперации = ВыбратьИзМеню(СписокВыбора);
		ФильтрОткрытиеФормыВыбора(ВидОперации);
	#Иначе
		ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ФильтрЗавершение", ЭтотОбъект), СписокВыбора);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрОткрытиеФормыВыбора(Знач ВидОперации)
	
	Если ВидОперации <> Неопределено Тогда
		Если ВидОперации.Значение = "ОтборПоКонтрагенту" Тогда
			ОткрытьФорму("Справочник.КонтрагентыМП.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ВидОперации = ВыбранныйЭлемент;
	ФильтрОткрытиеФормыВыбора(ВидОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ОчиститьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура Группировать(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	УстановитьГруппировкуПоКонтрагенту(НЕ ЭтаФорма.ГруппироватьПоКонтрагенту);
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура СодержимоеВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.СодержитЗначение Тогда
		ОткрытьФорму("Документ.ЗаказМП.ФормаОбъекта", Новый Структура("Ключ", Область.Значение));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ТабДокументДляОтправки = Новый ТабличныйДокумент;
	СформироватьНаСервере(ТабДокументДляОтправки, Истина);
	ОбщегоНазначенияМПКлиент.ОтправитьОтчетВCSV(Заголовок + " на " + формат(ТекущаяДата(), "ДЛФ=Д"), ТабДокументДляОтправки);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ТабДокументДляПечати = Новый ТабличныйДокумент;
	СформироватьНаСервере(ТабДокументДляПечати, Ложь, Истина);
	ТабДокументДляПечати.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	Если ОбщегоНазначенияМПВызовСервера.ЭтоСмартфон() Тогда
		ОтключитьОбработчикОжидания("СформироватьПриИзмененииПараметровЭкрана");
		ПодключитьОбработчикОжидания("СформироватьПриИзмененииПараметровЭкрана", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПриИзмененииПараметровЭкрана()
	
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/razdel-otchety/otchet-dolgi/");
	// АПК:534-вкл
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВPDF(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	СтруктураВозврата = ЗаписатьВPDF(КаталогДокументов());
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеЗапускаПриложения", ЭтотОбъект), СтруктураВозврата.ПолноеИмяФайла);

КонецПроцедуры

Процедура ПослеЗапускаПриложения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Возврат; // Процедура заглушка, т.к. НачатьЗапускПриложения требуется наличие обработчика оповещения.
КонецПроцедуры


&НаСервере
Функция ЗаписатьВPDF(КаталогДокументов)
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	СформироватьНаСервере(ПечатнаяФорма, Ложь, Истина);
	
	ИмяФайла = НСтр("ru='Отчет по взаиморасчетам с контрагентами от ';en='Mutual Settlements of '")
		+ ОбщегоНазначенияМПКлиентСервер.ПолучитьФорматированнуюСтрокуДатыДляФайла(ТекущаяДата()) + ".pdf";
	ПолноеИмяФайла = ОбщегоНазначенияМПКлиентСервер.ПолучитьПолноеИмяФайла(КаталогДокументов, ИмяФайла);     
	ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);             
	
	Возврат Новый Структура("ИмяФайла, ПолноеИмяФайла", ИмяФайла, ПолноеИмяФайла);

КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	
КонецПроцедуры

#КонецОбласти
