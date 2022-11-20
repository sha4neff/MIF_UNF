
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаскраситьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияСобытий" Тогда
		РаскраситьСписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РаскраситьСписок()
	
	// Раскраска списка
	СписокУдаляемыхЭлементов = Новый СписокЗначений;
	Для каждого ЭлементУсловногоОформления Из Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный" Тогда
			СписокУдаляемыхЭлементов.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	Для каждого Элемент Из СписокУдаляемыхЭлементов Цикл
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Удалить(Элемент.Значение);
	КонецЦикла;
	
	ВыборкаСостоянияСобытия = Справочники.СостоянияСобытий.Выбрать();
	Пока ВыборкаСостоянияСобытия.Следующий() Цикл
		
		ЦветФона = ВыборкаСостоянияСобытия.Цвет.Получить();
		Если ТипЗнч(ЦветФона) <> Тип("Цвет") Тогда
			Продолжить;
		КонецЕсли; 
		
		ЭлементУсловногоОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ВыборкаСостоянияСобытия.Ссылка;
		
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветФона);
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
		ЭлементУсловногоОформления.Представление = "По состоянию события " + ВыборкаСостоянияСобытия.Наименование;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
