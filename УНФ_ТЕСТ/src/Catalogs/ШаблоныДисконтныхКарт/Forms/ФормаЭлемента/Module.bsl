#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Определяет соответствует ли код карты шаблону
// На входе:
// ДанныеДорожек - Массив содержащий строки кода дорожки. Всего 3 Элемента.
// ДанныеШаблона - структура содержащая данные шаблона:
//	- Суффикс
//	- Префикс
//	- РазделительБлоков
//	- ДлинаКода
// На выходе:
// Истина - код соответствует шаблону
Функция КодСоответствуетШаблонуМК()
	
	// Проверяем только 2-ую дорожку.
	текСтрока = КодКарты;
	Если Прав(текСтрока, СтрДлина(Объект.Суффикс)) <> Объект.Суффикс
		ИЛИ Лев(текСтрока, СтрДлина(Объект.Префикс)) <> Объект.Префикс
		ИЛИ СтрНайти(текСтрока, Объект.РазделительБлоков) = 0
		ИЛИ (Объект.ДлинаКода <> 0 И СтрДлина(текСтрока) <> Объект.ДлинаКода) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия ="TracksData" Тогда
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			ТекДата = ТекущаяДата();
			
			ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод");
			КодКарты = Параметр[1][1][1]; // Код карты со 2-ой дорожки.
			
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			// Символ перевода строки можно обрезать с помощью настроек подключаемаого оборудования для считывателя магнитных карт.
			Пока (ТекущаяДата() - ТекДата) < 1 Цикл КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды ПроверитьКодПоШаблону формы.
//
&НаКлиенте
Процедура ПроверитьШаблон(Команда)
	
	Если Не ЗначениеЗаполнено(КодКарты) Тогда
		УправлениеНебольшойФирмойКлиент.СообщитьОбОшибке(ЭтаФорма, "Код карты (для примера) не заполнен",,,"КодКарты");
		Возврат;
	КонецЕсли;
	
	Если Объект.ДлинаКода > 0 Тогда
		ДлинаКодаДляПримера = СтрДлина(КодКарты);
		Если ДлинаКодаДляПримера <> Объект.ДлинаКода Тогда
			УправлениеНебольшойФирмойКлиент.СообщитьОбОшибке(ЭтаФорма, "Не правильно указана длина кода. Длина кода для примера = "+ДлинаКодаДляПримера+".",,,"Объект.ДлинаКода");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СписокШаблонов = Новый Массив;
		
	Если НЕ КодСоответствуетШаблонуМК() Тогда
		УправлениеНебольшойФирмойКлиент.СообщитьОбОшибке(ЭтотОбъект, "Не правильно указан префикс, суффикс или разделитель блоков");
		Возврат;
	КонецЕсли;
	
	ДанныеДорожки = Новый Массив;
	
	// Поиск блока по номеру
	ДанныеСтрока = КодКарты; // Обрабатываем данные только из 2-ой дорожки.
	Префикс = Объект.Префикс;
	Если Префикс = Лев(ДанныеСтрока, СтрДлина(Префикс)) Тогда
		ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-СтрДлина(Префикс)); // Удаляем префикс если есть
	КонецЕсли;
	Суффикс = Объект.Суффикс;
	Если Суффикс = Прав(ДанныеСтрока, СтрДлина(Суффикс)) Тогда
		ДанныеСтрока = Лев(ДанныеСтрока, СтрДлина(ДанныеСтрока)-СтрДлина(Суффикс)); // Удаляем суффикс если есть
	КонецЕсли;
	
	РазделительБлоков = Объект.РазделительБлоков;
	текНомерБлока = 0;
	Пока текНомерБлока < ?(Объект.НомерБлока = 0, 1, Объект.НомерБлока) Цикл
		ПозицияРазделителя = СтрНайти(ДанныеСтрока, РазделительБлоков);
		Если ПустаяСтрока(РазделительБлоков) ИЛИ ПозицияРазделителя = 0 Тогда
			Блок = ДанныеСтрока;
		ИначеЕсли ПозицияРазделителя = 1 Тогда
			Блок = "";
			ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-1);
		Иначе
			Блок = Лев(ДанныеСтрока, ПозицияРазделителя-1);
			ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-ПозицияРазделителя);
		КонецЕсли;
		текНомерБлока = текНомерБлока + 1;
	КонецЦикла;
	
	// Поиск подстроки в блоке
	ЗначениеПоля = Сред(Блок, Объект.НомерПервогоСимволаПоля, ?(Объект.ДлинаПоля = 0, СтрДлина(Блок), Объект.ДлинаПоля));
	
	КодКартыПоШаблону = ЗначениеПоля;
		
КонецПроцедуры

#КонецОбласти

