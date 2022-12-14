
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	УстановитьУсловноеОформление();
	
	Список.Параметры.УстановитьЗначениеПараметра("ОсновнойОтветственный",
		УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойОтветственный"));
	
	УстановитьОтборНедействительные(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	УстановитьОтборНедействительные(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКакОсновного(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или Элементы.Список.ТекущиеДанные.ЭтоОсновнойОтветственный 
		Или Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		
		Возврат;
	КонецЕсли;
	
	УстановитьОсновногоОтветственного(Элементы.Список.ТекущиеДанные.Ссылка);
	Элементы.ФормаИспользоватьКакОсновного.Доступность = Не Элементы.Список.ТекущиеДанные.ЭтоОсновнойОтветственный;
	
КонецПроцедуры

&НаКлиенте
Процедура Справка2НДФЛДляСотрудников(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено Тогда
		
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ТекущаяОрганизация = ТекущиеДанные.Организация;
	Если Не ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		ТекущаяОрганизация = РегламентированнаяОтчетностьУСН.ПолучитьТекущуюОрганизациюДляЦелейЗадачОтчетности();
	КонецЕсли;
	
	Если ПроверкаДанныхКлиент.ВыполнитьПроверкуДанныхДляСправки2НФДЛ(ТекущаяДата(), ТекущаяОрганизация, ТекущиеДанные.Ссылка) Тогда
		ОткрытьФорму("Документ.СправкаНДФЛ.Форма.ФормаДокумента",Новый Структура("Сотрудник, Организация", ТекущиеДанные.Ссылка, ТекущаяОрганизация),ЭтаФорма,УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка")
		И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Элементы.ФормаИспользоватьКакОсновного.Доступность = 
			Не Элементы.Список.ТекущиеДанные.ЭтоОсновнойОтветственный
			И Не Элементы.Список.ТекущиеДанные.ЭтоГруппа;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОсновногоОтветственного(знач НовыйОсновнойОтветственный)
	
	УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(НовыйОсновнойОтветственный, "ОсновнойОтветственный");
	Список.Параметры.УстановитьЗначениеПараметра("ОсновнойОтветственный", НовыйОсновнойОтветственный);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// 1. Недействительная номенклатура отображается серым
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительные(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры


#КонецОбласти
