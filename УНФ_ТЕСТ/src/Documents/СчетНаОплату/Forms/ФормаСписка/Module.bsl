
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Вызов из панели функций.
	Список.Параметры.УстановитьЗначениеПараметра("АкутальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	
	Если Элементы.ФильтрыНастройкиИДопИнфо.Видимость Тогда
		Элементы.ПраваяПанель.Ширина = 28;
	КонецЕсли;
	
	МассивИсключений = РаботаСОтборами.МассивИсключенийПоТипуДокумента("СчетНаОплату");
	РаботаСОтборами.ЗаполнитьСписокВыбораОтборОплата(ЭтаФорма, "ОтборОплата",, МассивИсключений);
	
	ЗаполнитьСписокВыбораОтборСостояниеОригинала();
	//Конец УНФ.ОтборыСписка
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	// КомандыПечати
	ПечатьДокументовУНФ.КорректировкаРазмещениеПодчиненнойГруппыКомандПечати(ЭтотОбъект, Элементы.ПодменюПечать,
		Элементы.ПодменюДоговорКонтрагента);
	Элементы.КомандыПечатиДоговорКонтрагента.Вид = ВидГруппыФормы.ГруппаКнопок;
	ШаблоныПечатиОфисныхДокументов.ОпределитьВидимостьКомандШаблоновПечати(
		Элементы.ФормаОткрытьШаблоныПечатиДоговоровКонтрагентов);
	
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	ПечатьДокументовУНФ.КорректировкаРазмещениеПодчиненнойГруппыКомандПечати(ЭтотОбъект, Элементы.ПодменюПечать,
		Элементы.ПодменюПечатьФаксимиле);
	Элементы.ПодменюПечатьФаксимиле.Вид = ВидГруппыФормы.Подменю;
	// Конец КомандыПечати
	
	// ЭДО
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ГруппаКомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект,
		"СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект,
		"СканерШтрихкода");
	// Конец ПодключаемоеОборудование 
	
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУНФКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭДО
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// УНФ.Интеграция с Яндекс.Кассой
	ИнтеграцияСЯндексКассойУНФКлиент.ОбработкаОповещения_ФормаСписка(Элементы.Список, ИмяСобытия, Параметр, Источник);
	// Конец УНФ.Интеграция с Яндекс.Кассой
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя, ЭтотОбъект, Элементы.Список, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		КонтрагентАктивнойСтроки = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Контрагент);
		Если КонтрагентАктивнойСтроки <> ТекущийКонтрагент Тогда
		
			ТекущийКонтрагент = КонтрагентАктивнойСтроки;
			ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОплатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	Если ВыбранноеЗначение = "Без оплаты"
		Или ВыбранноеЗначение = "Оплачен частично"
		Или ВыбранноеЗначение = "Оплачен полностью" Тогда
		УстановитьМеткуИОтборСписка("СтатусОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	Иначе
		УстановитьМеткуИОтборСписка("НомерКартинкиОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОригиналаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка") Тогда
		УстановитьМеткуИОтборСписка("СостояниеОригинала", Элемент.Родитель.Имя, ВыбранноеЗначение,
			УчетОригиналовПервичныхДокументовУНФКлиентСервер.СостояниеОригиналаНеизвестно());
	Иначе
		УстановитьМеткуИОтборСписка("СостояниеОригинала", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;

	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьШаблоныПечатиДоговоровКонтрагентов(Команда)
	
	УправлениеНебольшойФирмойКлиент.ОткрытьШаблоныПечатиОфисныхДокументов(
	ПредопределенноеЗначение("Перечисление.НазначенияШаблоновПечатиОфисныхДокументов.ДоговорКонтрагентаСчет"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)

	ТекШтрихкод = "";

	ОбработкаЗавершения = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект,
		Новый Структура("ТекШтрихкод", ТекШтрихкод));

	Если УправлениеНебольшойФирмойСервер.ЭтоМобильныйКлиент() Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаПоискаПоШтрихкоду", , , , , , ОбработкаЗавершения);
	Иначе
		ПоказатьВводЗначения(ОбработкаЗавершения, ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает событие активизации строки списка документов.
//
&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформацииСервер();

КонецПроцедуры

#Область ЗаполнениеСписковОтборов

&НаСервере
Процедура ЗаполнитьСписокВыбораОтборСостояниеОригинала()

	Элементы.ОтборСостояниеОригинала.СписокВыбора.Добавить(
		Справочники.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка(),
		УчетОригиналовПервичныхДокументовУНФКлиентСервер.СостояниеОригиналаНеизвестно());

	Для Каждого ТекСостояние Из УчетОригиналовПервичныхДокументов.ИспользуемыеСостояния() Цикл
		Элементы.ОтборСостояниеОригинала.СписокВыбора.Добавить(ТекСостояние.Ссылка, ТекСостояние.Наименование);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ГруппаРодительМетки = "ГруппаОтборОплата" Тогда
		ПредставлениеЗначения = РаботаСОтборами.СформироватьПредставлениеМеткиОплата(ВыбранноеЗначение);
		Если ИмяПоляОтбораСписка = "НомерКартинкиОплаты" Тогда
			ВыбранноеЗначение = РаботаСОтборами.НомерКартинкиПоСтатусуОплаты(ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли;
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);

КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
	Если Элементы.ФильтрыНастройкиИДопИнфо.Видимость Тогда
		Элементы.ПраваяПанель.Ширина = 28;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации


// УНФ.ПанельКонтактнойИнформации
&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтрагент);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока,
		Поле, СтандартнаяОбработка);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтрагент);
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда
		ТекШтрихкод = СокрЛП(Параметры.ТекШтрихкод);
	Иначе
		ТекШтрихкод = СокрЛП(Результат);
	КонецЕсли;
		
	Если ПустаяСтрока(ТекШтрихкод) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Штрихкод", ТекШтрихкод);
	Данные.Вставить("Количество", 1);
	
	ОбработатьШтрихкоды(Данные);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если ЗначениеЗаполнено(МассивСсылок)  Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетНаОплату.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// ЭДО
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
КонецПроцедуры
// Конец ЭДО

// СтандартныеПодсистемы.ПодключаемыеКоманды
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)

	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка("Документ.СчетНаОплату",
		Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, Элементы.Список.ТекущаяСтрока);

КонецПроцедуры

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	ОбновитьКомандыСостоянияОригинала();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
КонецПроцедуры
//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

#КонецОбласти

#КонецОбласти
