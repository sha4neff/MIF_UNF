
#Область ОбработчикиМетодовHTTP

#Область PING

Функция ОбработатьPING(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("ok");
	Возврат Ответ;
	
КонецФункции

Функция pingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

Функция itoolabsPingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

Функция mangoPingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

Функция yandexPingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

Функция rtPingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

#КонецОбласти

#Область MangoOffice

Функция mangoEventsCallPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/events/call";
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Использование телефонии Манго отключено в настройках'"));
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
	
	ПараметрыТела = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ТелоЗапроса, "&");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.MangoOffice, ПараметрыТела.sign, ПараметрыТела) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Неверно указана подпись запроса sign=%1'"), ПараметрыТела.sign));
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ПараметрыТела.json);
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("timestamp");
	ПараметрыЗапроса = ПрочитатьJSON(ЧтениеJSON,,,,"ВосстановлениеJSON",ТелефонияСервер,,МассивИмен);
	ЧтениеJSON.Закрыть();
	
	ОбязательныеПараметры = Новый Массив;
	ОбязательныеПараметры.Добавить("entry_id");
	ОбязательныеПараметры.Добавить("call_id");
	ОбязательныеПараметры.Добавить("timestamp");
	ОбязательныеПараметры.Добавить("seq");
	ОбязательныеПараметры.Добавить("call_state");
	ОбязательныеПараметры.Добавить("location");
	ОбязательныеПараметры.Добавить("to");
	ОбязательныеПараметры.Добавить("from");
	
	Для Каждого ОбязательныйПараметр Из ОбязательныеПараметры Цикл
		Если Не ПараметрыЗапроса.Свойство(ОбязательныйПараметр) Тогда
			Возврат СообщениеОбОшибке(
				400,
				ИмяСобытияДляЖурналаРегистрации,
				СтрШаблон(НСтр("ru='Отсутствует обязательный параметр %1.'"), ОбязательныйПараметр));
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Если НРег(ПараметрыЗапроса.location) = "abonent" Тогда
		
			Если ПараметрыЗапроса.call_state = "Appeared" Тогда
				
				Если ПараметрыЗапроса.from.Свойство("extension") И ПараметрыЗапроса.to.Свойство("number") Тогда
					
					ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
					ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.entry_id;
					ДанныеЗвонка.НомерКонтакта = ПараметрыЗапроса.to.number;
					ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.from.extension;
					ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыЗапроса.timestamp;
					
					ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
					
				ИначеЕсли ПараметрыЗапроса.from.Свойство("number") И ПараметрыЗапроса.to.Свойство("extension")
					И НЕ ПараметрыЗапроса.Свойство("command_id") Тогда
					
					ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
					ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.entry_id;
					ДанныеЗвонка.НомерКонтакта = ПараметрыЗапроса.from.number;
					ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.to.extension;
					ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыЗапроса.timestamp;
					Если ПараметрыЗапроса.to.Свойство("line_number") Тогда
						ДанныеЗвонка.НомерОрганизации = ПараметрыЗапроса.to.line_number;
					КонецЕсли;
					
					ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
					
				КонецЕсли;
				
			ИначеЕсли ПараметрыЗапроса.call_state = "Connected" Тогда
				
				Если ПараметрыЗапроса.to.Свойство("extension") Тогда
					Пользователь = ПараметрыЗапроса.to.extension;
				ИначеЕсли ПараметрыЗапроса.from.Свойство("extension") Тогда
					Пользователь = ПараметрыЗапроса.from.extension;
				КонецЕсли;
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.entry_id;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = Пользователь;
				ДанныеЗвонка.ДатаНачалаРазговора = ПараметрыЗапроса.timestamp;
				
				ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
				
			ИначеЕсли ПараметрыЗапроса.call_state = "Disconnected" Тогда
				
				Пользователь = Неопределено;
				Если ПараметрыЗапроса.to.Свойство("extension") Тогда
					Пользователь = ПараметрыЗапроса.to.extension;
				ИначеЕсли ПараметрыЗапроса.from.Свойство("extension") Тогда
					Пользователь = ПараметрыЗапроса.from.extension;
				КонецЕсли;
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.entry_id;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = Пользователь;
				ДанныеЗвонка.ДатаЗавершенияРазговора = ПараметрыЗапроса.timestamp;
				ДанныеЗвонка.ОпределятьНеотвеченный = Истина;
				
				ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

Функция mangoEventsRecordingPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/events/recording";
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Использование телефонии Манго отключено в настройках'"));
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ПараметрыТела = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ТелоЗапроса, "&");
	
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ПараметрыТела.json);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.MangoOffice, ПараметрыТела.sign, ПараметрыТела) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Неверно указана подпись запроса sign=%1'"), ПараметрыТела.sign));
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ПараметрыТела.json);
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("timestamp");
	ПараметрыЗапроса = ПрочитатьJSON(ЧтениеJSON,,,,"ВосстановлениеJSON",ТелефонияСервер,,МассивИмен);
	ЧтениеJSON.Закрыть();
	
	ОбязательныеПараметры = Новый Массив;
	ОбязательныеПараметры.Добавить("recording_id");
	ОбязательныеПараметры.Добавить("recording_state");
	ОбязательныеПараметры.Добавить("seq");
	ОбязательныеПараметры.Добавить("entry_id");
	ОбязательныеПараметры.Добавить("call_id");
	ОбязательныеПараметры.Добавить("timestamp");
	
	Для Каждого ОбязательныйПараметр Из ОбязательныеПараметры Цикл
		Если Не ПараметрыЗапроса.Свойство(ОбязательныйПараметр) Тогда
			Возврат СообщениеОбОшибке(
				400,
				ИмяСобытияДляЖурналаРегистрации,
				СтрШаблон(НСтр("ru='Отсутствует обязательный параметр %1.'"), ОбязательныйПараметр));
		КонецЕсли;
	КонецЦикла;
	
	НеобходимоОбработатьУведомление =
		ВРег(ПараметрыЗапроса.recording_state) = ВРег("Completed")
		И ПараметрыЗапроса.completion_code = 1000; // 1000 - Действие успешно выполнено
	
	Если НЕ НеобходимоОбработатьУведомление Тогда
		Ответ = Новый HTTPСервисОтвет(200);
		Возврат Ответ;
	КонецЕсли;
	
	Попытка
		ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
		ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.entry_id;
		ДанныеЗвонка.ЗаписьРазговора.Ссылка = ПараметрыЗапроса.recording_id;
		ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
	Исключение
		Возврат СообщениеОбОшибке(500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

Функция mangoResultCallbackPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/result/callback";
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Использование телефонии отключено в настройках'"));
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(501); // Not implemented
	Возврат Ответ;
	
КонецФункции

Функция mangoResultStatsPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/result/stats";
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Использование телефонии отключено в настройках'"));
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(501); // Not implemented
	Возврат Ответ;
	
КонецФункции

Функция mangoResultRoutePOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/result/route";
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Использование телефонии отключено в настройках'"));
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(501); // Not implemented
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область Itoolabs

Функция itoolabsEventPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/event";
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
	
	ПараметрыТела = ПолучитьПараметрыИзСтроки(ТелоЗапроса, "&");
	
	Если НЕ ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.ДомRu, ПараметрыТела.crm_token) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Некорректный ключ'"));
	КонецЕсли;
	
	ОбязательныеПараметры = "cmd";
	Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела,ОбязательныеПараметры) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
	КонецЕсли;
	
	ТипОперации = ПараметрыТела.cmd;
	Ответ = Неопределено;
	
	Попытка
		
		Если ТипОперации = "contact" Тогда
			
			ОбязательныеПараметры = "phone";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			ДанныеАбонента = ТелефонияСервер.ПолучитьДанныеКлиента(ПараметрыТела.phone);
			
			ЗаписьJSON = Неопределено;
			Если ДанныеАбонента <> Неопределено Тогда
				
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
				ЗаписьJSON.ЗаписатьНачалоОбъекта();
				
				ЗаписьJSON.ЗаписатьИмяСвойства("contact_name");
				ЗаписьJSON.ЗаписатьЗначение(ДанныеАбонента.Представление);
				
				Если ЗначениеЗаполнено(ДанныеАбонента.ВнутреннийНомерОтветственного) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("responsible");
					ЗаписьJSON.ЗаписатьЗначение(ДанныеАбонента.ВнутреннийНомерОтветственного);
				КонецЕсли;
				
				ЗаписьJSON.ЗаписатьКонецОбъекта();
				ПараметрыОтвета = ЗаписьJSON.Закрыть();
				
			КонецЕсли;
			
			Ответ = Новый HTTPСервисОтвет(200);
			Если ЗаписьJSON <> Неопределено Тогда
				Ответ.УстановитьТелоИзСтроки(ПараметрыОтвета);
			КонецЕсли;
			
		ИначеЕсли ТипОперации = "history" Тогда
			
			ОбязательныеПараметры = "callid,status";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
			ДанныеЗвонка.ЗаписьРазговора.Ссылка = ?(ПараметрыТела.Свойство("link"), ПараметрыТела.link, "");
			ДанныеЗвонка.ДлительностьРазговора = Число(ПараметрыТела.duration);
			Если НРег(ПараметрыТела.status) <> НРег("Success") Тогда
				ДанныеЗвонка.Неотвеченный = Истина;
			КонецЕсли;
			
			ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
			
		ИначеЕсли ТипОперации = "event" Тогда
			
			ОбязательныеПараметры = "type,callid,phone,ext";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			Если НРег(ПараметрыТела.type) = "incoming" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаЗвонка = ТекущаяДатаСеанса();
				ДанныеЗвонка.НомерКонтакта = ПараметрыТела.phone;
				ПараметрыТела.Свойство("diversion", ДанныеЗвонка.НомерОрганизации);
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "outgoing" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаЗвонка = ТекущаяДатаСеанса();
				ДанныеЗвонка.НомерКонтакта = ПараметрыТела.phone;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "accepted" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаРазговора = ТекущаяДатаСеанса();
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "completed" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				ДанныеЗвонка.Неотвеченный = Ложь;
				
				ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "cancelled" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				ДанныеЗвонка.Неотвеченный = Истина;
				
				ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
				
			КонецЕсли;
			
		Иначе
			
			Возврат СообщениеОбОшибке(501, ИмяСобытияДляЖурналаРегистрации); // Not implemented
			
		КонецЕсли;
		
	Исключение
		
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Если Ответ = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(200);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область Яндекс

Функция yandexEventPOST(Запрос)
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ЗаголовкиОтвет = Новый Структура("Echo", Запрос.Заголовки.Получить("Echo"));
	
	Если НЕ ЗначениеЗаполнено(ТелоЗапроса) Тогда // Проверочный запрос при первом подключении webhook в личном кабинете.
		Возврат НовыйHTTPСервисОтвет(200, ЗаголовкиОтвет);
	КонецЕсли;
	
	ИмяСобытияДляЖурналаРегистрации = "/event";
	
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
	ПараметрыЗапроса = ПрочитатьJSON(ЧтениеJSON,, "Timestamp", ФорматДатыJSON.ISO);
	ЧтениеJSON.Закрыть();
	
	Если НЕ ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.Яндекс, ПараметрыЗапроса.ApiKey) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Некорректный ApiKey'")),
			ЗаголовкиОтвет);
	КонецЕсли;
	
	ОбязательныеПараметры = "EventType";
	Если НЕ ЕстьОбязательныеПараметры(ПараметрыЗапроса, ОбязательныеПараметры) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры),
			ЗаголовкиОтвет);
	КонецЕсли;
	
	ТипСобытия = ПараметрыЗапроса.EventType;
	
	Попытка
		
		// Появление нового входящего звонка со внешнего номера {From} на бизнес номер {To}
		Если ТипСобытия = "IncomingCall" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.НомерКонтакта = ПараметрыЗапроса.Body.From;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.Body.To;
			ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.НомерОрганизации = ПараметрыЗапроса.Body.To;
			
			ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Ложь);
			
		// Начало дозвона до пользователя с указанным добавочным номером {Extension}
		ИначеЕсли ТипСобытия = "IncomingCallRinging" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.НомерКонтакта = ПараметрыЗапроса.Body.From;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.Body.Extension;
			
			ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
			
		// Неуспешная попытка дозвона до пользователя с добавочным номером {Extension}
		ИначеЕсли ТипСобытия = "IncomingCallStopRinging" Тогда 
			
		// Успешное соединение с пользователем с добавочным номером {Extension}
		ИначеЕсли ТипСобытия = "IncomingCallConnected" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.ДатаНачалаРазговора = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.Body.Extension;
			
			ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
			
		// Завершение входящего звонка
		ИначеЕсли ТипСобытия = "IncomingCallCompleted" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.ДатаЗавершенияРазговора = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.ЗаписьРазговора.ТребуетсяЗапросить = Истина;
			ДанныеЗвонка.ОпределятьНеотвеченный = Истина;
			
			ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
			
		// Начало исходящего звонка с бизнес номера {From} на внешний номер {To} пользователем с добавочным номером {Extension}
		ИначеЕсли ТипСобытия = "OutgoingCall" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.Body.Extension;
			ДанныеЗвонка.НомерКонтакта = ПараметрыЗапроса.Body.To;
			
			ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
			
		// Начало разговора при исходящем звонке
		ИначеЕсли ТипСобытия = "OutgoingCallConnected" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.ДатаНачалаРазговора = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыЗапроса.Body.Extension;
			
			ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
			
		// Завершение исходящего звонка
		ИначеЕсли ТипСобытия = "OutgoingCallCompleted" Тогда
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыЗапроса.Body.Id;
			ДанныеЗвонка.ДатаЗавершенияРазговора = ПараметрыЗапроса.Timestamp;
			ДанныеЗвонка.ЗаписьРазговора.ТребуетсяЗапросить = Истина;
			ДанныеЗвонка.ОпределятьНеотвеченный = Истина;
			
			ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
			
		// Появление заявки на обратный звонок с бизнес номера {From} на внешний номер {To}
		ИначеЕсли ТипСобытия = "CallbackCall" Тогда
			
		// Начало дозвона до пользователя с указанным добавочным номером {Extension} при обратном звонке
		ИначеЕсли ТипСобытия = "CallbackCallRinging" Тогда
			
		// Неуспешная попытка дозвона до пользователя с добавочным номером {Extension} при обратном звонке
		ИначеЕсли ТипСобытия = "CallbackCallStopRinging" Тогда
			
		// Пользователь с добавочным номером {Extension} соединился с номером {To} при обратном звонке
		ИначеЕсли ТипСобытия = "CallbackCallConnected" Тогда
			
		// Завершение обратного звонка
		ИначеЕсли ТипСобытия = "CallbackCallCompleted" Тогда
			
		КонецЕсли;
		
	Исключение
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			ЗаголовкиОтвет);
	КонецПопытки;
	
	Возврат НовыйHTTPСервисОтвет(200, ЗаголовкиОтвет);
	
КонецФункции

#КонецОбласти

#Область Ростелеком

Процедура rtПроверитьПодписьЗапроса(Запрос, ТелоЗапроса, ИмяСобытияДляЖурналаРегистрации, Ответ)
	
	ПодписьЗапросаЗаголовок = "X-Client-Sign";
	ПодписьЗапроса = Запрос.Заголовки.Получить(ПодписьЗапросаЗаголовок);
	
	Если ПодписьЗапроса = Неопределено Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru='В заголовках не передана подпись ""%1""'"), ПодписьЗапросаЗаголовок);
		Ответ = СообщениеОбОшибке(400, ИмяСобытияДляЖурналаРегистрации, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.Ростелеком, ПодписьЗапроса, ТелоЗапроса) Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru='Неверно указана подпись запроса ""%1""=""%2""'"), ПодписьЗапросаЗаголовок, ПодписьЗапроса);
		Ответ = СообщениеОбОшибке(400, ИмяСобытияДляЖурналаРегистрации, ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура rtПроверитьОбязательныеПараметры(ПараметрыТела, ИмяСобытияДляЖурналаРегистрации, Ответ)
	
	ОбязательныеПараметры = Новый Массив;
	ОбязательныеПараметры.Добавить("session_id");
	ОбязательныеПараметры.Добавить("timestamp");
	ОбязательныеПараметры.Добавить("type");
	ОбязательныеПараметры.Добавить("state");
	ОбязательныеПараметры.Добавить("from_number");
	ОбязательныеПараметры.Добавить("request_number");
	
	ПроверитьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры, ИмяСобытияДляЖурналаРегистрации, Ответ);
	
КонецПроцедуры

Функция rtCallEventsPOST(Запрос)
	
	Ответ = Неопределено;
	ИмяСобытияДляЖурналаРегистрации = "/call_events";
	
	ПроверитьИспользованиеТелефонииВНастройках(ИмяСобытияДляЖурналаРегистрации, Ответ);
	Если Ответ <> Неопределено Тогда
		Возврат Ответ;
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
	ДанныеЗапросаДляЛога = ТелефонияСервер.ПредставлениеСоответствияСтрокой(Запрос.Заголовки);
	ДанныеЗапросаДляЛога = ДанныеЗапросаДляЛога + Символы.ПС + ТелоЗапроса;
	
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ДанныеЗапросаДляЛога);
	
	rtПроверитьПодписьЗапроса(Запрос, ТелоЗапроса, ИмяСобытияДляЖурналаРегистрации, Ответ);
	Если Ответ <> Неопределено Тогда
		Возврат Ответ;
	КонецЕсли;
	
	ПараметрыТела = ТелефонияСервер.ПрочитатьJSONВСтруктуру(
		ТелоЗапроса,,, "ВосстановлениеСвойствСоЗначениямиДатаISO", ТелефонияСервер,, "timestamp");
	
	rtПроверитьОбязательныеПараметры(ПараметрыТела, ИмяСобытияДляЖурналаРегистрации, Ответ);
	Если Ответ <> Неопределено Тогда
		Возврат Ответ;
	КонецЕсли;
	
	Попытка
		
		ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
		ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.session_id;
		
		ТипУведомления = НРег(ПараметрыТела.state);
		Если ТипУведомления = "new" Тогда
			
			Если ПараметрыТела.type = "incoming" Тогда
				
				ДанныеЗвонка.НомерКонтакта = НомерТелефонаИзСтрокиSipURI(ПараметрыТела.from_number);
				ДанныеЗвонка.НомерОрганизации = НомерТелефонаИзСтрокиSipURI(ПараметрыТела.request_number);
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.request_pin;
				ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыТела.timestamp;
				ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
				
			Иначе
				
				ДанныеЗвонка.НомерКонтакта = НомерТелефонаИзСтрокиSipURI(ПараметрыТела.request_number);
				ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыТела.timestamp;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.from_pin;
				ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
				
			КонецЕсли;
			
		ИначеЕсли ТипУведомления = "calling" Тогда
			
			Если ПараметрыТела.type = "incoming" Тогда
				
				ДанныеЗвонка.НомерКонтакта = НомерТелефонаИзСтрокиSipURI(ПараметрыТела.from_number);
				ДанныеЗвонка.НомерОрганизации = НомерТелефонаИзСтрокиSipURI(ПараметрыТела.request_number);
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.request_pin;
				ДанныеЗвонка.ДатаНачалаЗвонка = ПараметрыТела.timestamp;
				ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
				
			КонецЕсли;
			
		ИначеЕсли ТипУведомления = "connected" Тогда
			
			Если ПараметрыТела.type = "incoming" Тогда
				Пользователь = ПараметрыТела.request_pin;
			Иначе
				Пользователь = ПараметрыТела.from_pin;
			КонецЕсли;
			
			ДанныеЗвонка.ДатаНачалаРазговора = ПараметрыТела.timestamp;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = Пользователь;
			ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
			
		ИначеЕсли ТипУведомления = "end" Тогда
			
			Если ПараметрыТела.type = "incoming" Тогда
				Пользователь = ПараметрыТела.request_pin;
			Иначе
				Пользователь = ПараметрыТела.from_pin;
			КонецЕсли;
			
			ДанныеЗвонка.ДатаЗавершенияРазговора = ПараметрыТела.timestamp;
			ДанныеЗвонка.Пользователь.ВнутреннийНомер = Пользователь;
			ДанныеЗвонка.ОпределятьНеотвеченный = Истина;
			Если ПараметрыТела.Свойство("is_record") Тогда
				ДанныеЗвонка.ЗаписьРазговора.ТребуетсяЗапросить = ПараметрыТела.is_record;
			КонецЕсли;
			ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
			
		КонецЕсли;
		
	Исключение
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Новый HTTPСервисОтвет(200);
	
КонецФункции

Функция rtGetNumberInfoPOST(Запрос)
	
	Ответ = Неопределено;
	ИмяСобытияДляЖурналаРегистрации = "/get_number_info";
	
	ПроверитьИспользованиеТелефонииВНастройках(ИмяСобытияДляЖурналаРегистрации, Ответ);
	Если Ответ <> Неопределено Тогда
		Возврат Ответ;
	КонецЕсли;
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ТелефонияПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
	
	УстановитьПривилегированныйРежим(Истина);
	
	// rtПроверитьПодписьЗапроса(Запрос, ТелоЗапроса, ИмяСобытияДляЖурналаРегистрации, Ответ);   // todo
	//Если Ответ <> Неопределено Тогда
	//	Возврат Ответ;
	//КонецЕсли;
	
	ПараметрыТела = ТелефонияСервер.ПрочитатьJSONВСтруктуру(ТелоЗапроса);
	
	ПроверитьОбязательныеПараметры(ПараметрыТела, "from_number", ИмяСобытияДляЖурналаРегистрации, Ответ);
	Если Ответ <> Неопределено Тогда
		Возврат Ответ;
	КонецЕсли;
	
	Попытка
		
		ТелефонияСервер.ОбработатьПолучениеИнформацииОВызывающемАбоненте(Перечисления.ДоступныеАТС.Ростелеком, НомерТелефонаИзСтрокиSipURI(ПараметрыТела.from_number), Ответ);
		Если Ответ <> Неопределено Тогда
			Возврат Ответ;
		КонецЕсли;
		
	Исключение
		
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат СообщениеОбОшибке(501, ИмяСобытияДляЖурналаРегистрации, НСтр("ru='Не выполнена обработка получения информации об абоненте.'"));
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьИспользованиеТелефонииВНастройках(ИмяСобытияЖР, Ответ)
	
	Ответ = Неопределено;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = НСтр("ru='Использование телефонии отключено в настройках'");
	Ответ = СообщениеОбОшибке(500, ИмяСобытияЖР, ТекстОшибки);
	
КонецПроцедуры

Процедура ПроверитьОбязательныеПараметры(ПараметрыЗапроса, ОбязательныеПараметры, ИмяСобытияЖР, Ответ)
	
	ОтсутствующиеПараметры = "";
	Если ЕстьОбязательныеПараметры(ПараметрыЗапроса, ОбязательныеПараметры, ОтсутствующиеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = СтрШаблон(НСтр("ru='Отсутствуют обязательные параметры: %1'"), ОтсутствующиеПараметры);
	Ответ = СообщениеОбОшибке(400, ИмяСобытияЖР, ТекстОшибки);
	
КонецПроцедуры

Функция ПолучитьПараметрыИзСтроки(Знач СтрокаПараметров, Знач Разделитель = ";")
	Результат = Новый Структура;
	
	ОписаниеПараметра = "";
	НайденоНачалоСтроки = Ложь;
	НомерПоследнегоСимвола = СтрДлина(СтрокаПараметров);
	Для НомерСимвола = 1 По НомерПоследнегоСимвола Цикл
		Символ =Сред(СтрокаПараметров, НомерСимвола, 1);
		Если Символ = """" Тогда
			НайденоНачалоСтроки = Не НайденоНачалоСтроки;
		КонецЕсли;
		Если Символ <> Разделитель Или НайденоНачалоСтроки Тогда
			ОписаниеПараметра = ОписаниеПараметра + Символ;
		КонецЕсли;
		Если Символ = Разделитель И Не НайденоНачалоСтроки Или НомерСимвола = НомерПоследнегоСимвола Тогда
			Позиция = СтрНайти(ОписаниеПараметра, "=");
			Если Позиция > 0 Тогда
				ИмяПараметра = СокрЛП(Лев(ОписаниеПараметра, Позиция - 1));
				ЗначениеПараметра = СокрЛП(Сред(ОписаниеПараметра, Позиция + 1));
				ЗначениеПараметра = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(ЗначениеПараметра);
				Попытка
					Результат.Вставить(ИмяПараметра, ЗначениеПараметра);
				Исключение
				КонецПопытки;
			КонецЕсли;
			ОписаниеПараметра = "";
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры, ОтсутствующиеПараметры = "")
	
	ОтсутствующиеПараметрыМассив = Новый Массив;
	
	Если ТипЗнч(ОбязательныеПараметры) = Тип("Строка") Тогда
		МассивПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбязательныеПараметры);
	Иначе
		МассивПараметров = ОбязательныеПараметры;
	КонецЕсли;
	
	Для Каждого ОбязательныйПараметр Из МассивПараметров Цикл
		Если НЕ ПараметрыТела.Свойство(ОбязательныйПараметр) Тогда
			ОтсутствующиеПараметрыМассив.Добавить(ОбязательныйПараметр);
		КонецЕсли;
	КонецЦикла;
	
	Если ОтсутствующиеПараметрыМассив.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОтсутствующиеПараметры = СтрСоединить(ОтсутствующиеПараметрыМассив, ",");
	
	Возврат Ложь;
	
КонецФункции

Функция СообщениеОбОшибке(КодСостояния, ВложенноеИмяСобытия, Комментарий = Неопределено, Заголовки = Неопределено)
	
	ЗаписьЖурналаРегистрации(
		ТелефонияПереопределяемый.СобытиеЖурналаРегистрации() + "." + ВложенноеИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,,,
		Комментарий);
	
	Возврат НовыйHTTPСервисОтвет(КодСостояния, Заголовки);
	
КонецФункции

Функция НовыйHTTPСервисОтвет(КодСостояния, Заголовки = Неопределено)
	
	Ответ = Новый HTTPСервисОтвет(КодСостояния);
	
	Если Заголовки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(Ответ.Заголовки, Заголовки);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция НомерТелефонаИзСтрокиSipURI(Знач НомерТелефона)
	
	Если НЕ СтрНачинаетсяС(НомерТелефона, "sip:") Тогда
		Возврат НомерТелефона;
	КонецЕсли;
	
	НомерТелефона = СтрЗаменить(НомерТелефона, "sip:", "");
	НомерТелефона = Лев(НомерТелефона, СтрНайти(НомерТелефона, "@") - 1);
	
	Возврат НомерТелефона;
	
КонецФункции

#КонецОбласти
