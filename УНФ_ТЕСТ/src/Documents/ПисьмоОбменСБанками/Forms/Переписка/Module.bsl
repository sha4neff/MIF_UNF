
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РеквизитыПисьма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.Письмо, "ИдентификаторПереписки, Организация, Банк");
	Организация = РеквизитыПисьма.Организация;
	Банк = РеквизитыПисьма.Банк;
	Запрос = Новый Запрос;
	ДополнительноеУсловие = "ПисьмоОбменСБанками.ИдентификаторПереписки = &ИдентификаторПереписки
				|	И ПисьмоОбменСБанками.ИдентификаторИсходногоПисьма = &ПустойИдентификатор";
	
	Запрос.Текст = ТекстЗапроса(ДополнительноеУсловие);
	Запрос.УстановитьПараметр("Организация", РеквизитыПисьма.Организация);
	Запрос.УстановитьПараметр("Банк", РеквизитыПисьма.Банк);
	Запрос.УстановитьПараметр("ИдентификаторПереписки", РеквизитыПисьма.ИдентификаторПереписки);
	ПустойИдентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Запрос.УстановитьПараметр("ПустойИдентификатор", ПустойИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	ДеревоЗначений = РеквизитФормыВЗначение("ДеревоПисем");
	Пока Выборка.Следующий() Цикл
		НовСтрока = ДеревоЗначений.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Выборка);
		ЗаполнитьПодчиненныеПисьмаРекурсивно(НовСтрока, Выборка.Идентификатор);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоПисем");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого СтрокаДерева Из ДеревоПисем.ПолучитьЭлементы() Цикл
		Элементы.ДеревоПисем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПодчиненныеПисьмаРекурсивно(ДеревоЗначений, ИдентификаторИсходногоПисьма)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса("ПисьмоОбменСБанками.ИдентификаторИсходногоПисьма = &ИдентификаторИсходногоПисьма");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.УстановитьПараметр("ИдентификаторИсходногоПисьма", ИдентификаторИсходногоПисьма);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовСтрока = ДеревоЗначений.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Выборка);
		ЗаполнитьПодчиненныеПисьмаРекурсивно(НовСтрока, Выборка.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапроса(ДополнительноеУсловие)

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПисьмоОбменСБанками.Ссылка,
	|	ВЫБОР
	|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭД.Входящий)
	|			ТОГДА ПисьмоОбменСБанками.Организация
	|		ИНАЧЕ ПисьмоОбменСБанками.Банк
	|	КОНЕЦ КАК Кому,
	|	ВЫБОР
	|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭД.Исходящий)
	|			ТОГДА ПисьмоОбменСБанками.Организация
	|		ИНАЧЕ ПисьмоОбменСБанками.Банк
	|	КОНЕЦ КАК ОтКого,
	|	ПисьмоОбменСБанками.ЕстьВложение,
	|	ПисьмоОбменСБанками.Тема,
	|	ПисьмоОбменСБанками.Дата,
	|	ПисьмоОбменСБанками.Идентификатор КАК Идентификатор,
	|	ВЫБОР
	|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭД.Входящий)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Вид
	|ИЗ
	|	Документ.ПисьмоОбменСБанками КАК ПисьмоОбменСБанками
	|ГДЕ
	|	ПисьмоОбменСБанками.Организация = &Организация
	|	И ПисьмоОбменСБанками.Банк = &Банк
	|	И ПисьмоОбменСБанками.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбменСБанками.Получен),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОбменСБанками.Отправлен))
	|	И ИСТИНА";

	Возврат СтрЗаменить(ТекстЗапроса, "ИСТИНА", ДополнительноеУсловие);
	
КонецФункции

&НаКлиенте
Процедура ДеревоПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение( , Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры


#КонецОбласти