#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыЗаполненияДокумента

// Обработчик заполнения на основании документа РасходныйОрдер.
//
// Параметры:
//  ДокументСсылкаРасходныйОрдер - ДокументСсылка.РасходныйОрдер.
//
Процедура ЗаполнитьПоРасходныйОрдер(ДокументСсылкаРасходныйОрдер) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаРасходныйОрдер;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаРасходныйОрдер,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(РасходныйОрдерЗапасы.НомерСтроки) КАК НомерСтроки,
	|	РасходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	РасходныйОрдерЗапасы.Характеристика КАК Характеристика,
	|	РасходныйОрдерЗапасы.Партия КАК Партия,
	|	РасходныйОрдерЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(РасходныйОрдерЗапасы.Количество) КАК Количество,
	|	РасходныйОрдерЗапасы.СерийныеНомера,
	|	РасходныйОрдерЗапасы.КлючСвязи
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК РасходныйОрдерЗапасы
	|ГДЕ
	|	РасходныйОрдерЗапасы.Ссылка = &ДокументОснование
	|СГРУППИРОВАТЬ ПО
	|	РасходныйОрдерЗапасы.Номенклатура,
	|	РасходныйОрдерЗапасы.Характеристика,
	|	РасходныйОрдерЗапасы.Партия,
	|	РасходныйОрдерЗапасы.ЕдиницаИзмерения,
	|	РасходныйОрдерЗапасы.СерийныеНомера,
	|	РасходныйОрдерЗапасы.КлючСвязи
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаРасходныйОрдер);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаРасходныйОрдер);
	
КонецПроцедуры

// Обработчик заполнения на основании документа ПриходнаяНакладная.
//
// Параметры:
//  ДокументСсылкаПриходнаяНакладная - ДокументСсылка.ПриходнаяНакладная.
//
Процедура ЗаполнитьПоПриходнаяНакладная(ДокументСсылкаПриходнаяНакладная) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПриходнаяНакладная;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПриходнаяНакладная,
		"Организация, СтруктурнаяЕдиница, Ячейка, ПоложениеСклада");
	
	Если ЗначенияРеквизитов.ПоложениеСклада = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		
		ЕстьОрдерныйСклад = ЕстьОрдерныйСкладВТабЧасти(ДокументСсылкаПриходнаяНакладная.Запасы);
		
		Если НЕ ЕстьОрдерныйСклад Тогда
			ВызватьИсключениеВводНаОсновании(ДокументСсылкаПриходнаяНакладная);
		КонецЕсли;
	Иначе
		ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПриходнаяНакладная, ЗначенияРеквизитов);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ПриходнаяНакладнаяЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПриходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	ПриходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	ПриходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	ПриходнаяНакладнаяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПриходнаяНакладнаяЗапасы.СерийныеНомера КАК СерийныеНомера,
	|	ПриходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ ВТ_ПриходнаяНакладнаяЗапасы
	|ИЗ
	|	Документ.ПриходнаяНакладная.Запасы КАК ПриходнаяНакладнаяЗапасы
	|ГДЕ
	|	ПриходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|	И (ПриходнаяНакладнаяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|	ИЛИ
	|		ПриходнаяНакладнаяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|	И ВЫБОР
	|		КОГДА
	|			ПриходнаяНакладнаяЗапасы.Ссылка.ПоложениеСклада = ЗНАЧЕНИЕ(Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти)
	|			ТОГДА ПриходнаяНакладнаяЗапасы.СтруктурнаяЕдиница.ОрдерныйСклад
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|СГРУППИРОВАТЬ ПО
	|	ПриходнаяНакладнаяЗапасы.Номенклатура,
	|	ПриходнаяНакладнаяЗапасы.Характеристика,
	|	ПриходнаяНакладнаяЗапасы.Партия,
	|	ПриходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	ПриходнаяНакладнаяЗапасы.СерийныеНомера,
	|	ПриходнаяНакладнаяЗапасы.КлючСвязи
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПриходнаяНакладнаяЗапасы.НомерСтроки,
	|	ВТ_ПриходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	ВТ_ПриходнаяНакладнаяЗапасы.Характеристика,
	|	ВТ_ПриходнаяНакладнаяЗапасы.Партия,
	|	ВТ_ПриходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	ВТ_ПриходнаяНакладнаяЗапасы.СерийныеНомера,
	|	ВТ_ПриходнаяНакладнаяЗапасы.КлючСвязи,
	|	ВЫБОР
	|		КОГДА ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток < 0
	|			ТОГДА -ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток
	|		ИНАЧЕ ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	ВТ_ПриходнаяНакладнаяЗапасы КАК ВТ_ПриходнаяНакладнаяЗапасы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыКПоступлениюНаСклады.Остатки(, Организация = &Организация
	|		И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыКПоступлениюНаСкладыОстатки
	|		ПО ВТ_ПриходнаяНакладнаяЗапасы.Номенклатура = ЗапасыКПоступлениюНаСкладыОстатки.Номенклатура
	|		И ВТ_ПриходнаяНакладнаяЗапасы.Характеристика = ЗапасыКПоступлениюНаСкладыОстатки.Характеристика
	|		И ВТ_ПриходнаяНакладнаяЗапасы.Партия = ЗапасыКПоступлениюНаСкладыОстатки.Партия
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПриходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	ПриходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	ПриходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	ПриходнаяНакладнаяСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	ПриходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ ВТ_ПриходнаяНакладнаяСерийныеНомера
	|ИЗ
	|	Документ.ПриходнаяНакладная.СерийныеНомера КАК ПриходнаяНакладнаяСерийныеНомера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная.Запасы КАК ПриходнаяНакладнаяЗапасы
	|		ПО ПриходнаяНакладнаяСерийныеНомера.Ссылка = &ДокументОснование
	|		И ПриходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|		И ПриходнаяНакладнаяЗапасы.КлючСвязи = ПриходнаяНакладнаяСерийныеНомера.КлючСвязи
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПриходнаяНакладнаяСерийныеНомера.СерийныйНомер,
	|	ВТ_ПриходнаяНакладнаяСерийныеНомера.КлючСвязи
	|ИЗ
	|	ВТ_ПриходнаяНакладнаяСерийныеНомера КАК ВТ_ПриходнаяНакладнаяСерийныеНомера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомераКПоступлению.Остатки(, Организация = &Организация
	|		И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК СерийныеНомераКПоступлениюОстатки
	|		ПО ВТ_ПриходнаяНакладнаяСерийныеНомера.Номенклатура = СерийныеНомераКПоступлениюОстатки.Номенклатура
	|		И ВТ_ПриходнаяНакладнаяСерийныеНомера.Характеристика = СерийныеНомераКПоступлениюОстатки.Характеристика
	|		И ВТ_ПриходнаяНакладнаяСерийныеНомера.Партия = СерийныеНомераКПоступлениюОстатки.Партия
	|		И ВТ_ПриходнаяНакладнаяСерийныеНомера.СерийныйНомер = СерийныеНомераКПоступлениюОстатки.СерийныйНомер");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПриходнаяНакладная);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запасы.Очистить();
	СерийныеНомера.Очистить();

	РезультатыЗапроса = Запрос.ВыполнитьПакет();

	Если РезультатыЗапроса[1].Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСерийныеНомера = РезультатыЗапроса[3].Выгрузить();
	ТаблицаСерийныеНомера.Индексы.Добавить("КлючСвязи");
	
	ВыборкаЗапасы = РезультатыЗапроса[1].Выбрать();
	Пока ВыборкаЗапасы.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаЗапасы.Количество) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрокаЗапасы = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЗапасы, ВыборкаЗапасы);
		Если РаботаССерийнымиНомерами.ИспользоватьСерийныеНомераОстатки() = Истина Тогда
			НоваяСтрокаЗапасы.СерийныеНомера = РаботаССерийнымиНомерами.ПредставлениеСерийныхНомеров(
				ТаблицаСерийныеНомера, НоваяСтрокаЗапасы.КлючСвязи)
		КонецЕсли;
	КонецЦикла;
	
	Если РаботаССерийнымиНомерами.ИспользоватьСерийныеНомераОстатки() = Истина Тогда
		СерийныеНомера.Загрузить(ТаблицаСерийныеНомера);
	Иначе
		РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПриходнаяНакладная);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик заполнения на основании документа ОприходованиеЗапасов.
//
// Параметры:
//  ДокументСсылкаОприходованиеЗапасов	 - ДокументСсылка.ОприходованиеЗапасов.
//
Процедура ЗаполнитьПоОприходованиеЗапасов(ДокументСсылкаОприходованиеЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаОприходованиеЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаОприходованиеЗапасов,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаОприходованиеЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ОприходованиеЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ОприходованиеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ОприходованиеЗапасовЗапасы.Характеристика КАК Характеристика,
	|	ОприходованиеЗапасовЗапасы.Партия КАК Партия,
	|	ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ОприходованиеЗапасовЗапасы.Количество) КАК Количество,
	|	ОприходованиеЗапасовЗапасы.СерийныеНомера,
	|	ОприходованиеЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ОприходованиеЗапасовЗапасы.Номенклатура,
	|	ОприходованиеЗапасовЗапасы.Характеристика,
	|	ОприходованиеЗапасовЗапасы.Партия,
	|	ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения,
	|	ОприходованиеЗапасовЗапасы.СерийныеНомера,
	|	ОприходованиеЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаОприходованиеЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаОприходованиеЗапасов);
	
КонецПроцедуры // ЗаполнитьПоОприходованиеЗапасов()

// Обработчик заполнения на основании документа ОприходованиеЗапасов.
//
// Параметры:
//  ДокументСсылкаПересортицаЗапасов	 - ДокументСсылка.ПересортицаЗапасов.
//
Процедура ЗаполнитьПоПересортицаЗапасов(ДокументСсылкаПересортицаЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПересортицаЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПересортицаЗапасов,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПересортицаЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ПересортицаЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПересортицаЗапасовЗапасы.НоменклатураОприходование КАК Номенклатура,
	|	ПересортицаЗапасовЗапасы.ХарактеристикаОприходование КАК Характеристика,
	|	ПересортицаЗапасовЗапасы.ПартияОприходование КАК Партия,
	|	ПересортицаЗапасовЗапасы.ЕдиницаИзмеренияОприходование КАК ЕдиницаИзмерения,
	|	СУММА(ПересортицаЗапасовЗапасы.Количество) КАК Количество,
	|	ПересортицаЗапасовЗапасы.СерийныеНомераОприходование КАК СерийныеНомера,
	|	ПересортицаЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПересортицаЗапасов.Запасы КАК ПересортицаЗапасовЗапасы
	|ГДЕ
	|	ПересортицаЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПересортицаЗапасовЗапасы.НоменклатураОприходование,
	|	ПересортицаЗапасовЗапасы.ХарактеристикаОприходование,
	|	ПересортицаЗапасовЗапасы.ПартияОприходование,
	|	ПересортицаЗапасовЗапасы.ЕдиницаИзмеренияОприходование,
	|	ПересортицаЗапасовЗапасы.СерийныеНомераОприходование,
	|	ПересортицаЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПересортицаЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПересортицаЗапасов, ,
		"СерийныеНомераОприходование");
	
КонецПроцедуры // ЗаполнитьПоПересортицаЗапасов()

// Обработчик заполнения на основании документа ПеремещениеЗапасов
//
// Параметры:
//  ДокументСсылкаПеремещениеЗапасов - ДокументСсылка.ПеремещениеЗапасов.
//
Процедура ЗаполнитьПоПеремещениеЗапасов(ДокументСсылкаПеремещениеЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПеремещениеЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПеремещениеЗапасов,
		"Организация, СтруктурнаяЕдиницаПолучатель, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПеремещениеЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиницаПолучатель;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ПеремещениеЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПеремещениеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ПеремещениеЗапасовЗапасы.Характеристика КАК Характеристика,
	|	ПеремещениеЗапасовЗапасы.Партия КАК Партия,
	|	ПеремещениеЗапасовЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ПеремещениеЗапасовЗапасы.Количество) КАК Количество,
	|	ПеремещениеЗапасовЗапасы.СерийныеНомера,
	|	ПеремещениеЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПеремещениеЗапасов.Запасы КАК ПеремещениеЗапасовЗапасы
	|ГДЕ
	|	ПеремещениеЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПеремещениеЗапасовЗапасы.Номенклатура,
	|	ПеремещениеЗапасовЗапасы.Характеристика,
	|	ПеремещениеЗапасовЗапасы.Партия,
	|	ПеремещениеЗапасовЗапасы.ЕдиницаИзмерения,
	|	ПеремещениеЗапасовЗапасы.СерийныеНомера,
	|	ПеремещениеЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПеремещениеЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПеремещениеЗапасов);
	
КонецПроцедуры // ЗаполнитьПоПеремещениеЗапасов()

// Обработчик заполнения на основании документа ОтчетПереработчика.
//
// Параметры:
//  ДокументСсылкаОтчетПереработчика - ДокументСсылка.ОтчетПереработчика.
//
Процедура ЗаполнитьПоОтчетПереработчика(ДокументСсылкаОтчетПереработчика) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаОтчетПереработчика;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаОтчетПереработчика,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаОтчетПереработчика, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ОтчетПереработчика.НомерСтроки) КАК НомерСтроки,
	|	ОтчетПереработчика.Номенклатура КАК Номенклатура,
	|	ОтчетПереработчика.Характеристика КАК Характеристика,
	|	ОтчетПереработчика.Партия КАК Партия,
	|	ОтчетПереработчика.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ОтчетПереработчика.Количество) КАК Количество,
	|	ОтчетПереработчика.СерийныеНомера,
	|	ОтчетПереработчика.КлючСвязи
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОтчетПереработчикаПродукция.НомерСтроки КАК НомерСтроки,
	|		ОтчетПереработчикаПродукция.Номенклатура КАК Номенклатура,
	|		ОтчетПереработчикаПродукция.Характеристика КАК Характеристика,
	|		ОтчетПереработчикаПродукция.Партия КАК Партия,
	|		ОтчетПереработчикаПродукция.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ОтчетПереработчикаПродукция.Количество КАК Количество,
	|		ОтчетПереработчикаПродукция.СерийныеНомера КАК СерийныеНомера,
	|		ОтчетПереработчикаПродукция.КлючСвязи КАК КлючСвязи
	|	ИЗ
	|		Документ.ОтчетПереработчика.Продукция КАК ОтчетПереработчикаПродукция
	|	ГДЕ
	|		ОтчетПереработчикаПродукция.Ссылка = &ДокументОснование
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОтчетПереработчикаОтходы.НомерСтроки,
	|		ОтчетПереработчикаОтходы.Номенклатура,
	|		ОтчетПереработчикаОтходы.Характеристика,
	|		ОтчетПереработчикаОтходы.Партия,
	|		ОтчетПереработчикаОтходы.ЕдиницаИзмерения,
	|		ОтчетПереработчикаОтходы.Количество,
	|		NULL,
	|		NULL
	|	ИЗ
	|		Документ.ОтчетПереработчика.Отходы КАК ОтчетПереработчикаОтходы
	|	ГДЕ
	|		ОтчетПереработчикаОтходы.Ссылка = &ДокументОснование) КАК ОтчетПереработчика
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтчетПереработчика.Номенклатура,
	|	ОтчетПереработчика.Характеристика,
	|	ОтчетПереработчика.Партия,
	|	ОтчетПереработчика.ЕдиницаИзмерения,
	|	ОтчетПереработчика.СерийныеНомера,
	|	ОтчетПереработчика.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаОтчетПереработчика);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерийныеНомера.Загрузить(ДокументСсылкаОтчетПереработчика.СерийныеНомера.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоОтчетПереработчика()

// Обработчик заполнения на основании документа ЗаказПоставщику.
//
// Параметры:
//  ДокументСсылкаЗаказПоставщику	 - ДокументСсылка.ЗаказПоставщику.
//
Процедура ЗаполнитьПоЗаказПоставщику(ДокументСсылкаЗаказПоставщику) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаЗаказПоставщику;
	Организация = ДокументСсылкаЗаказПоставщику.Организация;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(ЗаказПоставщикуЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ЗаказПоставщикуЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПоставщикуЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПоставщикуЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ЗаказПоставщикуЗапасы.Количество) КАК Количество
	|ИЗ
	|	Документ.ЗаказПоставщику.Запасы КАК ЗаказПоставщикуЗапасы
	|ГДЕ
	|	ЗаказПоставщикуЗапасы.Ссылка = &ДокументОснование
	|	И (ЗаказПоставщикуЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ИЛИ ЗаказПоставщикуЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщикуЗапасы.Номенклатура,
	|	ЗаказПоставщикуЗапасы.Характеристика,
	|	ЗаказПоставщикуЗапасы.ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаЗаказПоставщику);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоЗаказПоставщику()

// Обработчик заполнения на основании документа СборкаЗапасов.
//
// Параметры:
//  ДокументСсылкаСборкаЗапасов	 - ДокументСсылка.СборкаЗапасов.
//
Процедура ЗаполнитьПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов) Экспорт
	
	ИменаРеквизитов = Новый Массив;
	ИменаРеквизитов.Добавить("Организация");
	ИменаРеквизитов.Добавить("ВидОперации");
	ИменаРеквизитов.Добавить("СтруктурнаяЕдиница");
	ИменаРеквизитов.Добавить("Ячейка");
	ИменаРеквизитов.Добавить("СтруктурнаяЕдиницаПродукции");
	ИменаРеквизитов.Добавить("ЯчейкаПродукции");
	ИменаРеквизитов.Добавить("СтруктурнаяЕдиницаОтходов");
	ИменаРеквизитов.Добавить("ЯчейкаОтходов");
	ИменаРеквизитов.Добавить("ПоложениеСклада");
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаСборкаЗапасов, ИменаРеквизитов);
	
	МассивТЧОрдер = Новый Массив;
	
	ЗаполнитьШапкуПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов, ЗначенияРеквизитов, МассивТЧОрдер);
	
	ЗаполнитьТабличнуюЧастьПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов, ЗначенияРеквизитов, МассивТЧОрдер);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходныйОрдер")] = "ЗаполнитьПоРасходныйОрдер";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходнаяНакладная")] = "ЗаполнитьПоПриходнаяНакладная";
	СтратегияЗаполнения[Тип("ДокументСсылка.ОприходованиеЗапасов")] = "ЗаполнитьПоОприходованиеЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПересортицаЗапасов")] = "ЗаполнитьПоПересортицаЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПеремещениеЗапасов")] = "ЗаполнитьПоПеремещениеЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ОтчетПереработчика")] = "ЗаполнитьПоОтчетПереработчика";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПоставщику")] = "ЗаполнитьПоЗаказПоставщику";
	СтратегияЗаполнения[Тип("ДокументСсылка.СборкаЗапасов")] = "ЗаполнитьПоСборкаЗапасов";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПриходныйОрдер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыКПоступлениюНаСклады(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	
	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.ПриходныйОрдер.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.ПриходныйОрдер.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Серийные номера
	РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Запасы, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	// Подарочные сертификаты
	РаботаСПодарочнымиСертификатами.ПроверитьВозможностьИспользованияСертификатов(Отказ, ЭтотОбъект, "Запасы", "СтруктурнаяЕдиница", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет проверку возможности ввода на основании.
//
Процедура ПроверитьВозможностьВводаНаОсновании(ДокументСсылка, ЗначенияРеквизитов)
	
	Если ЗначенияРеквизитов.Свойство("СтруктурнаяЕдиница") Тогда
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.СтруктурнаяЕдиница)
				И НЕ ЗначенияРеквизитов.СтруктурнаяЕдиница.ОрдерныйСклад Тогда
			ВызватьИсключениеВводНаОсновании(ДокументСсылка);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначенияРеквизитов.Свойство("СтруктурнаяЕдиницаПолучатель") Тогда
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.СтруктурнаяЕдиницаПолучатель)
				И НЕ ЗначенияРеквизитов.СтруктурнаяЕдиницаПолучатель.ОрдерныйСклад Тогда
			ВызватьИсключениеВводНаОсновании(ДокументСсылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВызватьИсключениеВводНаОсновании(ДокументСсылка)
	
	ТекстИсключения = СтрШаблон(НСтр("ru = 'Невозможен ввод операции ""Поступления на ордерный склад"".
		|Документ ""%1"" не имеет ордерного склада.'"), ДокументСсылка);
	
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

Функция ЕстьОрдерныйСкладВТабЧасти(ТабЧасть)
	
	ЗначенияРеквизитовСкладТЧ = ТабЧасть.ВыгрузитьКолонку("СтруктурнаяЕдиница");
	ЗначенияОрдерныйСклад = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗначенияРеквизитовСкладТЧ, "ОрдерныйСклад");
	
	Для каждого складТЧ Из ЗначенияОрдерныйСклад Цикл
		Если СкладТЧ.Значение = Истина Тогда
			
			Возврат Истина;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнитьШапкуПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов, ЗначенияРеквизитов, МассивТЧОрдер)
	
	ДокументОснование = ДокументСсылкаСборкаЗапасов;
	
	Организация = ЗначенияРеквизитов.Организация;
	
	Если ЗначенияРеквизитов.ПоложениеСклада = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		
		Если ЕстьОрдерныйСкладВТабЧасти(ДокументСсылкаСборкаЗапасов.Продукция) Тогда
			МассивТЧОрдер.Добавить("Продукция");
		КонецЕсли; 
		Если ЕстьОрдерныйСкладВТабЧасти(ДокументСсылкаСборкаЗапасов.Запасы) Тогда
			МассивТЧОрдер.Добавить("Запасы");
		КонецЕсли; 
		
		СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиницаПродукции;
		Ячейка = ЗначенияРеквизитов.ЯчейкаПродукции;
						
	Иначе
		
		Если ЗначенияРеквизитов.СтруктурнаяЕдиница.ОрдерныйСклад Тогда
			
			Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
				МассивТЧОрдер.Добавить("Запасы");
				МассивТЧОрдер.Добавить("Отходы");
			Иначе
				МассивТЧОрдер.Добавить("Продукция");
				МассивТЧОрдер.Добавить("Отходы");
			КонецЕсли;
			
			СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиница;
			Ячейка = ЗначенияРеквизитов.Ячейка;
			
		Иначе
			
			Если ЗначенияРеквизитов.СтруктурнаяЕдиницаПродукции.ОрдерныйСклад Тогда
				
				Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
					МассивТЧОрдер.Добавить("Запасы");
				Иначе
					МассивТЧОрдер.Добавить("Продукция");
				КонецЕсли;
				
				СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиницаПродукции;
				Ячейка = ЗначенияРеквизитов.ЯчейкаПродукции;
								
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 
	Если ЗначенияРеквизитов.СтруктурнаяЕдиницаОтходов.ОрдерныйСклад Тогда
		МассивТЧОрдер.Добавить("Отходы");
	КонецЕсли;
	
	Если МассивТЧОрдер.Количество() = 0 Тогда
		ВызватьИсключениеВводНаОсновании(ДокументСсылкаСборкаЗапасов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов, ЗначенияРеквизитов, МассивТЧОрдер)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СборкаЗапасов.Продукция.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		СерийныеНомера КАК СерийныеНомера,
	|		СтруктурнаяЕдиница.ОрдерныйСклад КАК ОрдерныйСклад,
	|		КлючСвязи КАК КлючСвязи
	|	) КАК Продукция,
	|	СборкаЗапасов.Запасы.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		СерийныеНомера КАК СерийныеНомера,
	|		СтруктурнаяЕдиница.ОрдерныйСклад КАК ОрдерныйСклад,
	|		КлючСвязи КАК КлючСвязи
	|	) КАК Запасы,
	|	СборкаЗапасов.Отходы.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ЛОЖЬ КАК ОрдерныйСклад
	|	) КАК Отходы
	|ИЗ
	|	Документ.СборкаЗапасов КАК СборкаЗапасов
	|ГДЕ
	|	СборкаЗапасов.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаСборкаЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Для каждого ИмяТабличнойЧасти Из МассивТЧОрдер Цикл
		Для каждого СтрокаТаблицы Из Выборка[ИмяТабличнойЧасти].Выгрузить() Цикл
			
			Если ЗначенияРеквизитов.ПоложениеСклада = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти
					И ИмяТабличнойЧасти <> "Отходы" Тогда
				Если СтрокаТаблицы.ОрдерныйСклад Тогда
					НоваяСтрока = Запасы.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				КонецЕсли;
			Иначе
				НоваяСтрока = Запасы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
		РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаСборкаЗапасов);
	Иначе
		РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаСборкаЗапасов,
			"Продукция", "СерийныеНомераПродукция");
	КонецЕсли;
	
КонецПроцедуры 


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли