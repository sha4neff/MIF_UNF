
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ИспользоватьВидыЗаказов = УправлениеНебольшойФирмойВызовСервера.ПолучитьФункциональнуюОпциюСервер("ИспользоватьВидыЗаказНарядов");
	
	Если ИспользоватьВидыЗаказов Тогда
		Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора
			И Параметры.Свойство("ВидЗаказа") И ЗначениеЗаполнено(Параметры.ВидЗаказа) Тогда
			
			ВыбраннаяФорма = "Справочник.ВидыЗаказНарядов.Форма.ФормаСпискаЭтапов";
		Иначе
			ВыбраннаяФорма = "Справочник.СостоянияЗаказНарядов.Форма.ФормаСписка";
		КонецЕсли;
	Иначе
		ВыбраннаяФорма = "Справочник.СостоянияЗаказНарядов.Форма.ФормаСпискаСостоянийОсновногоВида";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказНарядов") Тогда
		Параметры.Вставить("ВидЗаказа", Справочники.ВидыЗаказНарядов.Основной);
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	КоличествоЭлементовБыстрогоВыбора = 15;
	ДобавлятьПорядок = Истина;
	
	Если Параметры.Свойство("ВидЗаказа") И ЗначениеЗаполнено(Параметры.ВидЗаказа) Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 15
			|	ВидыЗаказНарядовПорядокСостояний.Состояние КАК Состояние,
			|	ВидыЗаказНарядовПорядокСостояний.Состояние.Наименование КАК Наименование,
			|	ВидыЗаказНарядовПорядокСостояний.Состояние.Цвет КАК Цвет
			|ИЗ
			|	Справочник.ВидыЗаказНарядов.ПорядокСостояний КАК ВидыЗаказНарядовПорядокСостояний
			|ГДЕ
			|	ВидыЗаказНарядовПорядокСостояний.Ссылка = &ВидЗаказа
			|	И ВидыЗаказНарядовПорядокСостояний.Состояние.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	ВидыЗаказНарядовПорядокСостояний.НомерСтроки";
		
		Запрос.УстановитьПараметр("ВидЗаказа", Параметры.ВидЗаказа);
		
	Иначе
		
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 15
			|	СостоянияЗаказНарядов.Ссылка КАК Состояние,
			|	СостоянияЗаказНарядов.Наименование КАК Наименование,
			|	СостоянияЗаказНарядов.Цвет КАК Цвет
			|ИЗ
			|	Справочник.СостоянияЗаказНарядов КАК СостоянияЗаказНарядов
			|ГДЕ
			|	СостоянияЗаказНарядов.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Наименование";
		
		ДобавлятьПорядок = Ложь;
		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "15", КоличествоЭлементовБыстрогоВыбора);
	Выборка = Запрос.Выполнить().Выбрать();
	НомерПоПорядку = 0;
	ЖирныйШрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
	
	Пока Выборка.Следующий() Цикл
		
		НомерПоПорядку = НомерПоПорядку + 1;
		Цвет = Выборка.Цвет.Получить();
		Если Цвет = Неопределено Тогда
			Цвет = ЦветаСтиля.ЦветТекстаПоля;
		КонецЕсли;
		
		КомпонентыФС = Новый Массив;
		Если ДобавлятьПорядок Тогда
			КомпонентыФС.Добавить(Строка(НомерПоПорядку) + ". ");
		КонецЕсли;
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(
			Выборка.Наименование,
			?(Выборка.Состояние = Справочники.СостоянияЗаказНарядов.Завершен, ЖирныйШрифт, Неопределено),
			Цвет
		));
		
		ДанныеВыбора.Добавить(Выборка.Состояние, Новый ФорматированнаяСтрока(КомпонентыФС));
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Процедура заполняет справочник по умолчанию
//
Процедура ЗаполнитьПоставляемыеСостояния() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СостоянияЗаказНарядов.Ссылка
		|ИЗ
		|	Справочник.СостоянияЗаказНарядов КАК СостоянияЗаказНарядов
		|ГДЕ
		|	СостоянияЗаказНарядов.Предопределенный = ЛОЖЬ";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		// 1. Состояние "В работе"
		Состояние = Справочники.СостоянияЗаказНарядов.СоздатьЭлемент();
		Состояние.Наименование	= НСтр("ru='В работе'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		// 2. Состояние "Завершен"
		Состояние = Справочники.СостоянияЗаказНарядов.Завершен.ПолучитьОбъект();
		Состояние.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ПрошедшееСобытие);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить справочник ""Состояния заказ-нарядов"" по умолчанию по причине:
				|%1'"), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.СостоянияЗаказНарядов, , ТекстСообщения);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли