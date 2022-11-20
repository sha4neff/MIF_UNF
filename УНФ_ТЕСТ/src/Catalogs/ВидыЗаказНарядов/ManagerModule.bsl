#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	КоличествоЭлементовБыстрогоВыбора = 15;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 99
		|	ВидыЗаказНарядов.Ссылка КАК ВидЗаказа,
		|	ВидыЗаказНарядов.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ВидыЗаказНарядов КАК ВидыЗаказНарядов
		|ГДЕ
		|	ВидыЗаказНарядов.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "99", КоличествоЭлементовБыстрогоВыбора);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеВыбора.Добавить(Выборка.ВидЗаказа, Выборка.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Процедура заполняет основной вид заказа. Должна вызываться после заполнения справочника состояний.
//
Процедура ЗаполнитьОсновнойВидЗаказа() Экспорт
	
	ВидЗаказа = Справочники.ВидыЗаказНарядов.Основной.ПолучитьОбъект();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияЗаказНарядов.Ссылка КАК Состояние,
		|	ВЫБОР
		|		КОГДА СостоянияЗаказНарядов.Ссылка = ЗНАЧЕНИЕ(Справочник.СостоянияЗаказНарядов.Завершен)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЗавершенПоследним
		|ИЗ
		|	Справочник.СостоянияЗаказНарядов КАК СостоянияЗаказНарядов
		|ГДЕ
		|	СостоянияЗаказНарядов.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗавершенПоследним,
		|	СостоянияЗаказНарядов.Наименование";
	
	Состояния = Запрос.Выполнить().Выгрузить();
	
	ВидЗаказа.ПорядокСостояний.Загрузить(Состояния);
	ВидЗаказа.СостояниеВыполнения = Справочники.СостоянияЗаказНарядов.Завершен;
	ВидЗаказа.НомерСостоянияВыполнения = ВидЗаказа.ПорядокСостояний.Количество();
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидЗаказа);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли