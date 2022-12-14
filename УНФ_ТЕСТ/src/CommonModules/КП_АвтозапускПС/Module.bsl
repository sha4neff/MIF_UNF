// Общий модуль (выполняется на стороне сервера) модуля "Конструктор процессов для 1С:УНФ"
// Разработчик Компания "Аналитика. Проекты и решения" +7 495 005-1653, https://kp-unf.ru
// Вызовы являются повторными на время сеанса

#Область СлужебныеПроцедурыИФункции

// Функция возвращает список элементов автозапуска по полному имени типа источника
// Параметры:
//	ПолноеИмяТипа - строка с полным именем типа источника
// Возвращаемое значение: Список значений
Функция ПолучитьСписокАвтозапускаПоНаименованиюИсточника(ПолноеИмяТипа) Экспорт
	
	ПолноеИмя=СтрЗаменить(ПолноеИмяТипа, "Ссылка.", ".");
	
	//найдем в списке метаданных
	СсылкаНаМетаданные=Справочники.КП_СписокМетаданных.НайтиПоРеквизиту("ПолноеНаименование", ПолноеИмя);
	
	Список=Новый СписокЗначений;
	
	Если СсылкаНаМетаданные=Неопределено Тогда
		Возврат Список;
	КонецЕсли;
	
	//получим элементы автозапуска
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_АвтозапускПроцессов.Ссылка КАК Ссылка
	                    |ИЗ
	                    |	Справочник.КП_АвтозапускПроцессов КАК КП_АвтозапускПроцессов
	                    |ГДЕ
	                    |	КП_АвтозапускПроцессов.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_АвтозапускПроцессов.Включено = ИСТИНА
	                    |	И КП_АвтозапускПроцессов.ВидМетаданных = &ВидМетаданных");
	
	Запрос.УстановитьПараметр("ВидМетаданных", СсылкаНаМетаданные);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Пока Выборка.Следующий() Цикл
		АвтозапускСсылка=Выборка.Ссылка;
		Если Список.НайтиПоЗначению(АвтозапускСсылка)=Неопределено Тогда
			Список.Добавить(АвтозапускСсылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

#КонецОбласти
