
//////////////////////////////////////////////////////////////////////////////// 
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура заполняет таблицу запасов.
//
&НаСервере
Процедура ЗаполнитьТаблицуЗапасов()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация",		ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент",			ОтборКонтрагент);
	Запрос.УстановитьПараметр("Договор",			ОтборДоговор);
	Запрос.УстановитьПараметр("ВалютаРасчетов",		ОтборДоговор.ВалютаРасчетов);
	Запрос.УстановитьПараметр("ВалютаДокумента",	ВалютаДокумента);
	Запрос.УстановитьПараметр("ВидЦенКонтрагента",	ВидЦенКонтрагента);
	Запрос.УстановитьПараметр("ВалютаВидаЦен",		ВидЦенКонтрагента.ВалютаЦены);
	Запрос.УстановитьПараметр("ВалютаУчета",		Константы.ВалютаУчета.Получить());
	
	Запрос.УстановитьПараметр("НачалоПериода",		НачалоДня(ОтборДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода",		КонецДня(ОтборДатаОкончания));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродажиОбороты.Номенклатура КАК Номенклатура,
	|	ПродажиОбороты.Характеристика КАК Характеристика,
	|	ПродажиОбороты.Партия КАК Партия,
	|	ПродажиОбороты.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ПродажиОбороты.Контрагент КАК Покупатель,
	|	ПродажиОбороты.КоличествоОборот КАК Количество,
	|	ПродажиОбороты.КоличествоОборот КАК Остаток,
	|	ВЫБОР
	|		КОГДА ПродажиОбороты.КоличествоОборот > 0
	|			ТОГДА ВЫБОР
	|					КОГДА &ВалютаДокумента = &ВалютаУчета
	|						ТОГДА ПродажиОбороты.СуммаОборот / ПродажиОбороты.КоличествоОборот
	|					ИНАЧЕ ЕСТЬNULL(ПродажиОбороты.СуммаОборот * КурсВалютыУчета.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыУчета.Кратность), 0) / ПродажиОбороты.КоличествоОборот
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА ПродажиОбороты.КоличествоОборот > 0
	|			ТОГДА ВЫБОР
	|					КОГДА &ВалютаДокумента = &ВалютаУчета
	|						ТОГДА ПродажиОбороты.СуммаОборот
	|					ИНАЧЕ ЕСТЬNULL(ПродажиОбороты.СуммаОборот * КурсВалютыУчета.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыУчета.Кратность), 0)
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА &ВалютаДокумента = &ВалютаВидаЦен
	|				ТОГДА ФиксированныеЦеныПоступления.Цена
	|			ИНАЧЕ ФиксированныеЦеныПоступления.Цена * КурсВалютыВидаЦен.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыВидаЦен.Кратность)
	|		КОНЕЦ, ВЫБОР
	|			КОГДА ЗапасыПринятыеОстатки.КоличествоОстаток > 0
	|				ТОГДА ВЫБОР
	|						КОГДА &ВалютаДокумента = &ВалютаРасчетов
	|							ТОГДА ЗапасыПринятыеОстатки.СуммаРасчетовОстаток / ЗапасыПринятыеОстатки.КоличествоОстаток
	|						ИНАЧЕ ЕСТЬNULL(ЗапасыПринятыеОстатки.СуммаРасчетовОстаток * КурсВалютыРасчетов.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыРасчетов.Кратность), 0) / ЗапасыПринятыеОстатки.КоличествоОстаток
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЦенаПоступления,
	|	ЗапасыПринятыеОстатки.Заказ КАК ЗаказПоставщику
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И Партия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.ТоварыНаКомиссии)
	|				И Партия.ВладелецПартии = &Контрагент) КАК ПродажиОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыПринятые.Остатки(
	|				&КонецПериода,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И ТипПриемаПередачи = ЗНАЧЕНИЕ(Перечисление.ТипыПриемаПередачиТоваров.ПоступлениеОтКомитента)) КАК ЗапасыПринятыеОстатки
	|		ПО (ЗапасыПринятыеОстатки.Номенклатура = ПродажиОбороты.Номенклатура)
	|			И (ЗапасыПринятыеОстатки.Характеристика = ПродажиОбороты.Характеристика)
	|			И (ЗапасыПринятыеОстатки.Партия = ПродажиОбороты.Партия)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(
	|				&КонецПериода,
	|				ВидЦенКонтрагента = &ВидЦенКонтрагента
	|					И Актуальность) КАК ФиксированныеЦеныПоступления
	|		ПО (ФиксированныеЦеныПоступления.Номенклатура = ПродажиОбороты.Номенклатура)
	|			И (ФиксированныеЦеныПоступления.Характеристика = ПродажиОбороты.Характеристика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&КонецПериода, Валюта = &ВалютаРасчетов) КАК КурсВалютыРасчетов
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&КонецПериода, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&КонецПериода, Валюта = &ВалютаУчета) КАК КурсВалютыУчета
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&КонецПериода, Валюта = &ВалютаВидаЦен) КАК КурсВалютыВидаЦен
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПродажиОбороты.КоличествоОборот > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Партия";
	
	ТаблицаЗапасов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьТаблицуЗапасов()

// Функция помещает результаты подбора в хранилище
//
&НаСервере
Функция ПоместитьЗапасыВХранилище()
	
	Запасы = ТаблицаЗапасов.Выгрузить(, "Выбран, Номенклатура, Характеристика, Партия, ЗаказПокупателя, ЗаказПоставщику, Покупатель, ДатаРеализации, Количество, Остаток, Цена, Сумма, ЦенаПоступления");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаЗапасы Из Запасы Цикл
		
		Если Не СтрокаЗапасы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаЗапасы);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого НомерСтроки Из МассивУдаляемыхСтрок Цикл
		Запасы.Удалить(НомерСтроки);
	КонецЦикла;
	
	АдресЗапасовВХранилище = ПоместитьВоВременноеХранилище(Запасы, УникальныйИдентификатор);
	
	Возврат АдресЗапасовВХранилище;
	
КонецФункции // ПоместитьЗапасыВХранилище()

// Процедура заполняет таблицу периодов.
//
Процедура ЗаполнитьПериодПродаж()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетКомитенту.Дата КАК Дата
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ОтчетКомитенту
	|ГДЕ
	|	ОтчетКомитенту.Проведен
	|	И ОтчетКомитенту.Организация = &Организация
	|	И ОтчетКомитенту.Контрагент = &Контрагент
	|	И ОтчетКомитенту.Договор = &Договор
	|	И ОтчетКомитенту.Дата < &ДатаДокумента
	|	И ОтчетКомитенту.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("Контрагент",		ОтборКонтрагент);
	Запрос.УстановитьПараметр("Договор",		ОтборДоговор);
	Запрос.УстановитьПараметр("Ссылка",			ТекущийДокумент);
	Запрос.УстановитьПараметр("ДатаДокумента",	КонецДня(ОтборДатаОкончания));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ОтборДатаНачала = Дата('00010101');
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ОтборДатаНачала = НачалоДня(Выборка.Дата+86400);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПериодПродаж()

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ КОМАНД

// Процедура - обработчик команды УстановитьИнтервал.
//
&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период.ДатаНачала = ОтборДатаНачала;
	Диалог.Период.ДатаОкончания = ОтборДатаОкончания;
	
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект, Новый Структура("Диалог", Диалог)));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ОтборДатаНачала = Диалог.Период.ДатаНачала;
		ОтборДатаОкончания = Диалог.Период.ДатаОкончания;
		ЗаполнитьТаблицуЗапасов();
	КонецЕсли;
	
КонецПроцедуры // УстановитьИнтервал()

// Процедура - обработчик команды ВыбратьСтроки.
//
&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТабличнойЧасти Из ТаблицаЗапасов Цикл
		
		СтрокаТабличнойЧасти.Выбран = Истина;
		
	КонецЦикла;
	
КонецПроцедуры // ВыбратьСтрокиВыполнить()

// Процедура - обработчик команды ИсключитьСтроки.
//
&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТабличнойЧасти Из ТаблицаЗапасов Цикл
		
		СтрокаТабличнойЧасти.Выбран = Ложь
		
	КонецЦикла;
	
КонецПроцедуры // ИсключитьСтрокиВыполнить()

// Процедура - обработчик команды ВыбратьВыделенные.
//
&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЗапасов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗапасов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаТабличнойЧасти.Выбран = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыбратьВыделенныеСтроки()

// Процедура - обработчик команды ИсключитьВыделенные.
//
&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЗапасов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗапасов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаТабличнойЧасти.Выбран = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ИсключитьВыделенныеСтроки()

// Процедура - обработчик команды ПеренестиВДокумент.
//
&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	АдресЗапасовВХранилище = ПоместитьЗапасыВХранилище();
	ОповеститьОВыборе(АдресЗапасовВХранилище);
	
КонецПроцедуры // ПеренестиВДокументВыполнить()

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборОрганизация	= Параметры.Компания;
	Организация			= Параметры.Организация;
	ОтборКонтрагент 	= Параметры.Контрагент;
	ОтборДоговор 		= Параметры.Договор;
	ВалютаДокумента 	= Параметры.ВалютаДокумента;
	ВидЦенКонтрагента 	= Параметры.ВидЦенКонтрагента;
	ТекущийДокумент 	= Параметры.ТекущийДокумент;
	ОтборДатаОкончания 	= Параметры.ДатаДокумента;
	
	ЗаполнитьПериодПродаж();
	
	ЗаполнитьТаблицуЗапасов();
	
КонецПроцедуры // ПриСозданииНаСервере()

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

// Процедура - обработчик события ПриИзменении поля ОтборДатаНачала.
//
&НаКлиенте
Процедура ОтборДатаНачалаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуЗапасов();
	
КонецПроцедуры // ОтборДатаНачалаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ОтборДатаОкончания.
//
&НаКлиенте
Процедура ОтборДатаОкончанияПриИзменении(Элемент)
	
	ЗаполнитьТаблицуЗапасов();
	
КонецПроцедуры // ОтборДатаОкончанияПриИзменении()

// Процедура - обработчик события Выбор табличной части ТаблицаЗапасов.
//
&НаКлиенте
Процедура ТаблицаЗапасовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаЗапасов.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаЗапасовЗаказПокупателя" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаЗапасов.ТекущиеДанные.ЗаказПокупателя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ТаблицаЗапасовВыбор()

// Процедура - обработчик события ПриИзменении поля Количество табличной части ТаблицаЗапасов.
//
&НаКлиенте
Процедура ТаблицаЗапасовКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	СтрокаТабличнойЧасти.Выбран = (СтрокаТабличнойЧасти.Количество <> 0);
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	
КонецПроцедуры // ТаблицаЗапасовКоличествоПриИзменении()

#КонецОбласти
