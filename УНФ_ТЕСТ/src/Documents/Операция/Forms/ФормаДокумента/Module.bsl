////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	РазностьДат = УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"РазностьДат",
		РазностьДат
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"Компания",
		УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация)
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры СчетПриИзменении.
//
// Параметры:
//  Счет         - ПланСчетовСсылка, счет по которому нужно получить структуру.
//
// Возвращаемое значение:
//  Структура счета.
// 
Функция ПолучитьДанныеСчетПриИзменении(Счет) Экспорт
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить("Валютный", Счет.Валютный);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеСчетПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриЧтенииНаСервере()

////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода СчетДт.
// Табличной части Проводки.
//
Процедура ПроводкиСчетДтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетДт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.ВалютаДт = Неопределено;
		ТекущаяСтрока.СуммаВалДт = 0;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСчетДтПриИзменении()

&НаКлиенте
// Процедура - обработчик события НачалоВыбора поля ввода ВалютаДт.
// Табличной части Проводки.
//
Процедура ПроводкиВалютаДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетДт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетДт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиВалютаДтНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВалютаДт.
// Табличной части Проводки.
//
Процедура ПроводкиВалютаДтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетДт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.ВалютаДт = Неопределено;
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетДт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиВалютаДтПриИзменении()

&НаКлиенте
// Процедура - обработчик события НачалоВыбора поля ввода СуммаВалДт.
// Табличной части Проводки.
//
Процедура ПроводкиСуммаВалДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетДт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетДт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСуммаВалДтНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода СуммаВалДт.
// Табличной части Проводки.
//
Процедура ПроводкиСуммаВалДтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетДт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.СуммаВалДт = 0;
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетДт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСуммаВалДтПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода СчетКт.
// Табличной части Проводки.
//
Процедура ПроводкиСчетКтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетКт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.ВалютаКт = Неопределено;
		ТекущаяСтрока.СуммаВалКт = 0;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСчетКтПриИзменении()

&НаКлиенте
// Процедура - обработчик события НачалоВыбора поля ввода ВалютаКт.
// Табличной части Проводки.
//
Процедура ПроводкиВалютаКтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетКт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетКт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиВалютаКтНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВалютаКт.
// Табличной части Проводки.
//
Процедура ПроводкиВалютаКтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетКт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.ВалютаКт = Неопределено;
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетКт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиВалютаКтПриИзменении()

&НаКлиенте
// Процедура - обработчик события НачалоВыбора поля ввода СуммаВалКт.
// Табличной части Проводки.
//
Процедура ПроводкиСуммаВалКтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетКт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетКт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСуммаВалКтНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода СуммаВалКт.
// Табличной части Проводки.
//
Процедура ПроводкиСуммаВалКтПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Проводки.ТекущиеДанные;
	СтруктураДанные = ПолучитьДанныеСчетПриИзменении(ТекущаяСтрока.СчетКт);
	
	Если НЕ СтруктураДанные.Валютный Тогда
		ТекущаяСтрока.СуммаВалКт = 0;
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущаяСтрока.СчетКт) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'У выбранного счета не установлен признак валютный!'"));
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Укажите в начале счет!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроводкиСуммаВалКтПриИзменении()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
