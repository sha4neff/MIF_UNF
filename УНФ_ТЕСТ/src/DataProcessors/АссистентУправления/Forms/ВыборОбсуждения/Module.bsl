
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
	Отбор.Групповое = Истина;
	Отбор.Отображаемое = Истина;
	Отбор.ТекущийПользовательЯвляетсяУчастником = Истина;
	Отбор.НаправлениеСортировки = НаправлениеСортировки.Возр;
	ВсеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
	Для Каждого Обсуждение Из ВсеОбсуждения Цикл
		НовоеОбсуждение = СписокОбсуждений.Добавить();
		НовоеОбсуждение.ИдентификаторОбсуждения = Строка(Обсуждение.Идентификатор);
		НовоеОбсуждение.ТемаОбсуждения          = Обсуждение.Заголовок;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("СозданиеОбсужденияЗавершение",ЭтотОбъект);
	ОткрытьФорму("Обработка.АссистентУправления.Форма.СозданиеОбсуждения",,,,,,ОповещениеОЗакрытии);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущееОбсуждение = Новый Структура;
	ТекущееОбсуждение.Вставить("Тема", Элементы.СписокОбсуждений.ТекущиеДанные.ТемаОбсуждения);
	ТекущееОбсуждение.Вставить("Идентификатор", Элементы.СписокОбсуждений.ТекущиеДанные.ИдентификаторОбсуждения);
	Закрыть(ТекущееОбсуждение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СозданиеОбсужденияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	СозданиеОбсужденияЗавершениеСервер(Результат);
	Элементы.СписокОбсуждений.ТекущаяСтрока = 0;
КонецПроцедуры

&НаСервере
Процедура СозданиеОбсужденияЗавершениеСервер(Результат)
	
	Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
	Отбор.Групповое = Истина;
	Отбор.Отображаемое = Истина;
	Отбор.ТекущийПользовательЯвляетсяУчастником = Истина;
	ВсеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
	СписокОбсуждений.Очистить();
	Для Каждого Обсуждение Из ВсеОбсуждения Цикл
		Если Обсуждение.Идентификатор = Результат Тогда
			НовоеОбсуждение = СписокОбсуждений.Вставить(0);
		Иначе
			НовоеОбсуждение = СписокОбсуждений.Добавить();
		КонецЕсли;
		НовоеОбсуждение.ИдентификаторОбсуждения = Обсуждение.Идентификатор;
		НовоеОбсуждение.ТемаОбсуждения          = Обсуждение.Заголовок;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти