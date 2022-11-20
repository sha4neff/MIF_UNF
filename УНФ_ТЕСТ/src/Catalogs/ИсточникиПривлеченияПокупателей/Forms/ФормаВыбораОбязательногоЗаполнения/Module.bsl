
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбязательноеЗаполнениеИсточникаПривлечения = Константы.ОбязательноЗаполнятьИсточникПривлечения.Получить();
	МассивОбъектов = РегистрыСведений.ОбязательностьЗаполненияРеквизитов.ОбъектыДляОбязательногоЗаполненияРеквизита("ИсточникПривлечения");
	
	Для Каждого Объект Из МассивОбъектов Цикл
		
		Если Объект = "Лид" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеЛиды = Истина;
		ИначеЕсли Объект = "Покупатель" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеПокупатели = Истина;
		ИначеЕсли Объект = "Контакт" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеКонтакты = Истина;
		ИначеЕсли Объект = "ЗаказПокупателя" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеЗаказы = Истина;
		ИначеЕсли Объект = "ЗаказНаряд" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеЗаказНаряды = Истина;
		ИначеЕсли Объект = "ЭлектронноеПисьмо" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеПисьма = Истина;
		ИначеЕсли Объект = "ТелефонныйЗвонок" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеЗвонки = Истина;
		ИначеЕсли Объект = "Встреча" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеВстречи = Истина;
		ИначеЕсли Объект = "Запись" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеЗаписи = Истина;
		ИначеЕсли Объект = "SMS" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеSMS = Истина;
		ИначеЕсли Объект = "ПрочиеСобытия" Тогда
			ЭтотОбъект.ОбязательноеЗаполнениеСобытиеПрочее = Истина;
		Иначе
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;

	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьДанныеОбязательностиЗаполнения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ОбязательноеЗаполнениеИсточникаПривлеченияПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедуры

&НаСервере
Процедура ЗаписатьДанныеОбязательностиЗаполнения()
	
	НаборЗаписей = РегистрыСведений.ОбязательностьЗаполненияРеквизитов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Реквизит.Установить("ИсточникПривлечения");
	
	ЗаписьЛид = НаборЗаписей.Добавить();
	ЗаписьЛид.Объект = "Лид";
	ЗаписьЛид.Реквизит = "ИсточникПривлечения";
	ЗаписьЛид.ОбязательноеЗаполнение = ОбязательноеЗаполнениеЛиды;
		
	ЗаписьЗаказ = НаборЗаписей.Добавить();
	ЗаписьЗаказ.Объект = "ЗаказПокупателя";
	ЗаписьЗаказ.Реквизит = "ИсточникПривлечения";
	ЗаписьЗаказ.ОбязательноеЗаполнение = ОбязательноеЗаполнениеЗаказы;
	
	ЗаписьЗаказНаряд = НаборЗаписей.Добавить();
	ЗаписьЗаказНаряд.Объект = "ЗаказНаряд";
	ЗаписьЗаказНаряд.Реквизит = "ИсточникПривлечения";
	ЗаписьЗаказНаряд.ОбязательноеЗаполнение = ОбязательноеЗаполнениеЗаказНаряды;
	
	ЗаписьЗвонок = НаборЗаписей.Добавить();
	ЗаписьЗвонок.Объект = "ТелефонныйЗвонок";
	ЗаписьЗвонок.Реквизит = "ИсточникПривлечения";
	ЗаписьЗвонок.ОбязательноеЗаполнение = ОбязательноеЗаполнениеЗвонки;

	ЗаписьПисьмо = НаборЗаписей.Добавить();
	ЗаписьПисьмо.Объект = "ЭлектронноеПисьмо";
	ЗаписьПисьмо.Реквизит = "ИсточникПривлечения";
	ЗаписьПисьмо.ОбязательноеЗаполнение = ОбязательноеЗаполнениеПисьма;

	ЗаписьЗаписи = НаборЗаписей.Добавить();
	ЗаписьЗаписи.Объект = "Запись";
	ЗаписьЗаписи.Реквизит = "ИсточникПривлечения";
	ЗаписьЗаписи.ОбязательноеЗаполнение = ОбязательноеЗаполнениеЗаписи;
	
	ЗаписьВстреча = НаборЗаписей.Добавить();
	ЗаписьВстреча.Объект = "Встреча";
	ЗаписьВстреча.Реквизит = "ИсточникПривлечения";
	ЗаписьВстреча.ОбязательноеЗаполнение = ОбязательноеЗаполнениеВстречи;
	
	ЗаписьВстреча = НаборЗаписей.Добавить();
	ЗаписьВстреча.Объект = "Покупатель";
	ЗаписьВстреча.Реквизит = "ИсточникПривлечения";
	ЗаписьВстреча.ОбязательноеЗаполнение = ОбязательноеЗаполнениеПокупатели;
	
	ЗаписьКонтакт = НаборЗаписей.Добавить();
	ЗаписьКонтакт.Объект = "Контакт";
	ЗаписьКонтакт.Реквизит = "ИсточникПривлечения";
	ЗаписьКонтакт.ОбязательноеЗаполнение = ОбязательноеЗаполнениеКонтакты;
	
	ЗаписьSMS = НаборЗаписей.Добавить();
	ЗаписьSMS.Объект = "SMS";
	ЗаписьSMS.Реквизит = "ИсточникПривлечения";
	ЗаписьSMS.ОбязательноеЗаполнение = ОбязательноеЗаполнениеSMS;
	
	ЗаписьСобытиеПрочее = НаборЗаписей.Добавить();
	ЗаписьСобытиеПрочее.Объект = "ПрочиеСобытия";
	ЗаписьСобытиеПрочее.Реквизит = "ИсточникПривлечения";
	ЗаписьСобытиеПрочее.ОбязательноеЗаполнение = ОбязательноеЗаполнениеСобытиеПрочее;

	НаборЗаписей.Записать(Истина);
	
	Константы.ОбязательноЗаполнятьИсточникПривлечения.Установить(ОбязательноеЗаполнениеИсточникаПривлечения);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ГруппаОбъекты.Доступность = ОбязательноеЗаполнениеИсточникаПривлечения;
	
	Если ОбязательноеЗаполнениеИсточникаПривлечения Тогда
		Возврат;
	КонецЕсли;
	
	ОбязательноеЗаполнениеВстречи = Ложь;
	ОбязательноеЗаполнениеЗаказНаряды = Ложь;
	ОбязательноеЗаполнениеЗаказы = Ложь;
	ОбязательноеЗаполнениеЗаписи = Ложь;
	ОбязательноеЗаполнениеЗвонки = Ложь;
	ОбязательноеЗаполнениеИсточникаПривлечения = Ложь;
	ОбязательноеЗаполнениеЛиды = Ложь;
	ОбязательноеЗаполнениеПисьма = Ложь;
	ОбязательноеЗаполнениеПокупатели = Ложь;
	ОбязательноеЗаполнениеSMS = Ложь;
	ОбязательноеЗаполнениеКонтакты = Ложь;
	ОбязательноеЗаполнениеСобытиеПрочее = Ложь;
	
КонецПроцедуры

#КонецОбласти
