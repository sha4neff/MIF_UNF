#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСерия				= НСтр("ru = ', серия: %1'");
	ТекстНомер				= НСтр("ru = ', № %1'");
	ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1 года'");
	ТекстСрокДействия		= НСтр("ru = ', действует до: %1 года'");
	ТекстКодПодразделения	= НСтр("ru = ', № подр. %1'");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.ВидДокумента.Пустая() Тогда
			Запись.Представление = "";
			
		Иначе
			Запись.Представление = ""
				+ Запись.ВидДокумента
				+ ?(ЗначениеЗаполнено(Запись.Серия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, Запись.Серия), "")
				+ ?(ЗначениеЗаполнено(Запись.Номер), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, Запись.Номер), "")
				+ ?(ЗначениеЗаполнено(Запись.ДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(Запись.ДатаВыдачи,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(Запись.СрокДействия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСрокДействия, Формат(Запись.СрокДействия,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(Запись.КемВыдан), ", " + Запись.КемВыдан, "")
				+ ?(ЗначениеЗаполнено(Запись.КодПодразделения) И Запись.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКодПодразделения, Запись.КодПодразделения), "");
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДокументов",	Выгрузить(, "Физлицо, Период, ЯвляетсяДокументомУдостоверяющимЛичность"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокументов.Физлицо КАК Физлицо,
	|	ТаблицаДокументов.Период КАК Период
	|ПОМЕСТИТЬ ВТ_Документы
	|ИЗ
	|	&ТаблицаДокументов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.ЯвляетсяДокументомУдостоверяющимЛичность
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Документы КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыФизическихЛиц.Физлицо,
	|	ДокументыФизическихЛиц.Период
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) > 1";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстСообщения = НСтр("ru = 'На %1 у физлица %2 уже введен документ, удостоверяющий личность.'");
	
	Пока Выборка.Следующий() Цикл
		Отказ = Истина;
		
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, Формат(Выборка.Период, "ДЛФ=D"), Выборка.Физлицо));
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		СтруктураЗаписи = Новый Структура("Период, Физлицо, ВидДокумента");
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
		
		КлючЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьКлючЗаписи(СтруктураЗаписи);
		
		
		Если Не ПустаяСтрока(Запись.Номер) Тогда
			ТекстОшибки = "";
			Отказ = Не ДокументыФизическихЛицКлиентСервер.НомерДокументаУказанПравильно(Запись.ВидДокумента, Запись.Номер, ТекстОшибки) Или Отказ;
			Если Не ПустаяСтрока(ТекстОшибки) Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.Номер");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли